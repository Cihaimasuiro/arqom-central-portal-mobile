import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/performance_models.dart';
import '../../data/performance_service.dart';

class WeeklyReviewTab extends StatefulWidget {
  final VoidCallback onDataChanged;

  const WeeklyReviewTab({
    super.key,
    required this.onDataChanged,
  });

  @override
  State<WeeklyReviewTab> createState() => _WeeklyReviewTabState();
}

class _WeeklyReviewTabState extends State<WeeklyReviewTab> {
  bool _isLoading = true;
  bool _isSubmitting = false;
  String? _errorMessage;
  WeeklyReviewData? _reviewData;

  DateTime _currentWeekDate = DateTime.now();

  // Local state for editing review items
  final Map<int, String> _itemStatus = {};
  final Map<int, double> _itemProgress = {};
  final Map<int, TextEditingController> _obstacleControllers = {};
  final Map<int, TextEditingController> _improvementControllers = {};

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void dispose() {
    for (final c in _obstacleControllers.values) {
      c.dispose();
    }
    for (final c in _improvementControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  String _formatDate(DateTime dt) {
    return "${dt.year.toString().padLeft(4, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}";
  }

  Future<void> _fetchData({bool silent = false}) async {
    if (!silent) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    final dateStr = _formatDate(_currentWeekDate);
    final res = await PerformanceService.getWeeklyReview(weekDate: dateStr);

    if (mounted) {
      setState(() {
        _isLoading = false;
        if (res.success && res.data != null) {
          _reviewData = res.data;
          _initLocalFormState(res.data!);
        } else {
          _errorMessage = res.message;
        }
      });
    }
  }

  void _initLocalFormState(WeeklyReviewData data) {
    // Clear old controllers
    for (final c in _obstacleControllers.values) {
      c.dispose();
    }
    for (final c in _improvementControllers.values) {
      c.dispose();
    }
    _obstacleControllers.clear();
    _improvementControllers.clear();
    _itemStatus.clear();
    _itemProgress.clear();

    for (final plan in data.plans) {
      for (final item in plan.items) {
        _itemStatus[item.id] = item.executionStatus;
        _itemProgress[item.id] = item.progressPercent.toDouble().clamp(0.0, 100.0);

        _obstacleControllers[item.id] =
            TextEditingController(text: item.obstacle ?? '');
        _improvementControllers[item.id] =
            TextEditingController(text: item.improvementPlan ?? '');
      }
    }
  }

  void _shiftWeek(int days) {
    setState(() {
      _currentWeekDate = _currentWeekDate.add(Duration(days: days));
    });
    _fetchData();
  }

  Future<void> _pickWeekDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _currentWeekDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.onSurface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _currentWeekDate = picked;
      });
      _fetchData();
    }
  }

  void _onStatusChanged(int itemId, String newStatus) {
    setState(() {
      _itemStatus[itemId] = newStatus;
      if (newStatus == 'completed') {
        _itemProgress[itemId] = 100.0;
      } else if (newStatus == 'not_started') {
        _itemProgress[itemId] = 0.0;
      } else if (newStatus == 'in_progress') {
        final current = _itemProgress[itemId] ?? 0.0;
        if (current <= 0.0 || current >= 100.0) {
          _itemProgress[itemId] = 50.0;
        }
      }
    });
  }

  Future<void> _submitBatchReview() async {
    if (_reviewData == null) return;

    final allItems = <WeeklyReviewItem>[];
    for (final p in _reviewData!.plans) {
      allItems.addAll(p.items);
    }

    if (allItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tidak ada item untuk dievaluasi pada pekan ini.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final itemsPayload = <String, dynamic>{};
      for (final item in allItems) {
        final status = _itemStatus[item.id] ?? item.executionStatus;
        final isCompleted = status == 'completed';
        final isNotStarted = status == 'not_started';
        final progress = isCompleted ? 100 : (isNotStarted ? 0 : (_itemProgress[item.id]?.round() ?? 0));

        final improvement = isCompleted
            ? (_improvementControllers[item.id]?.text.trim().isNotEmpty == true
                ? _improvementControllers[item.id]!.text.trim()
                : null)
            : null;

        final obstacle = !isCompleted
            ? (_obstacleControllers[item.id]?.text.trim().isNotEmpty == true
                ? _obstacleControllers[item.id]!.text.trim()
                : null)
            : null;

        itemsPayload[item.id.toString()] = {
          'execution_status': status,
          'progress_percent': progress,
          'improvement_plan': improvement,
          'obstacle': obstacle,
        };
      }

      final dateStr = _formatDate(_currentWeekDate);
      final res = await PerformanceService.submitWeeklyReviewBatch(
        weekDate: dateStr,
        items: itemsPayload,
      );

      if (!mounted) return;

      if (res.success) {
        widget.onDataChanged();
        _fetchData(silent: true);
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 24),
                const SizedBox(width: 8),
                const Text('Review Tersimpan!', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            content: Text(
              res.message,
              style: const TextStyle(fontSize: 13),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Tutup', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res.message),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'urgent':
        return AppColors.error;
      case 'high':
        return Colors.orange.shade800;
      case 'normal':
        return AppColors.primary;
      case 'low':
      default:
        return AppColors.secondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Week Date Navigation Bar
        _buildWeekNavigator(),
        const SizedBox(height: 16),

        if (_isLoading)
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          )
        else if (_errorMessage != null)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Column(
                children: [
                  const Icon(Icons.cloud_off, size: 48, color: AppColors.error),
                  const SizedBox(height: 12),
                  Text(
                    _errorMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.error, fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => _fetchData(),
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('Coba Lagi'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          _buildReviewContent(),
      ],
    );
  }

  Widget _buildWeekNavigator() {
    final label = _reviewData?.week.label.isNotEmpty == true
        ? _reviewData!.week.label
        : _formatDate(_currentWeekDate);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, color: AppColors.primary),
            onPressed: () => _shiftWeek(-7),
            tooltip: 'Pekan Sebelumnya',
            visualDensity: VisualDensity.compact,
          ),
          Expanded(
            child: InkWell(
              onTap: _pickWeekDate,
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.calendar_today, size: 16, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Pekan Evaluasi',
                            style: TextStyle(fontSize: 10, color: AppColors.outline, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_drop_down, color: AppColors.outline, size: 18),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, color: AppColors.primary),
            onPressed: () => _shiftWeek(7),
            tooltip: 'Pekan Berikutnya',
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }

  Widget _buildReviewContent() {
    final data = _reviewData;
    if (data == null) return const SizedBox.shrink();

    final allItems = <WeeklyReviewItem>[];
    for (final p in data.plans) {
      allItems.addAll(p.items);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Review Timing Banner
        _buildTimingBanner(data),
        const SizedBox(height: 14),

        // Summary Scorecard
        _buildSummaryScorecard(data.summary),
        const SizedBox(height: 16),

        // Guidelines Card
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primaryContainer.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_outline, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Aturan Evaluasi: Jika status "Selesai", progres otomatis 100% dan isi rencana perbaikan. Jika "Sedang Berjalan", isi kendala yang dihadapi. Sistem akan otomatis menghitung ulang capaian Anda.',
                  style: const TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant, height: 1.3),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // Section Title
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Item Evaluasi Mingguan (${allItems.length})',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 12),

        if (allItems.isEmpty)
          _buildEmptyState()
        else ...[
          ...allItems.map((item) => _buildReviewItemCard(item)),
          const SizedBox(height: 16),

          // Submit Batch Button
          ElevatedButton.icon(
            onPressed: _isSubmitting ? null : _submitBatchReview,
            icon: _isSubmitting
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                : const Icon(Icons.send_rounded, size: 18),
            label: Text(
              _isSubmitting
                  ? 'Menyimpan & Menghitung Ulang...'
                  : 'Simpan Sekaligus (${allItems.length} Item Evaluasi)',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 2,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ],
    );
  }

  Widget _buildTimingBanner(WeeklyReviewData data) {
    final timing = data.reviewTiming ?? 'upcoming';
    final isUpcoming = timing.toLowerCase() == 'upcoming';
    final reviewDate = data.reviewDate ?? '-';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (isUpcoming ? AppColors.secondary : Colors.green).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isUpcoming ? Icons.schedule : Icons.check_circle_outline,
              color: isUpcoming ? AppColors.secondary : Colors.green,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jadwal Review Akhir Pekan',
                  style: TextStyle(fontSize: 10, color: AppColors.outline, fontWeight: FontWeight.w500),
                ),
                Text(
                  reviewDate,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: (isUpcoming ? AppColors.secondary : Colors.green).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              isUpcoming ? 'UPCOMING' : 'AKTIF',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: isUpcoming ? AppColors.secondary : Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryScorecard(WeeklyReviewSummary summary) {
    final avg = summary.averageProgress.toDouble().clamp(0.0, 100.0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Circular Progress Indicator
          SizedBox(
            width: 60,
            height: 60,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: avg / 100.0,
                  strokeWidth: 6,
                  backgroundColor: AppColors.outlineVariant.withValues(alpha: 0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    avg >= 80 ? Colors.green : AppColors.primary,
                  ),
                ),
                Center(
                  child: Text(
                    '${avg.toStringAsFixed(0)}%',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Stats text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Rata-rata Capaian Pekan Ini',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '${summary.completedItems} dari ${summary.totalItems} target selesai',
                      style: const TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: summary.totalItems > 0 ? (summary.completedItems / summary.totalItems) : 0,
                    minHeight: 4,
                    backgroundColor: AppColors.surfaceContainerLow,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItemCard(WeeklyReviewItem item) {
    final status = _itemStatus[item.id] ?? item.executionStatus;
    final isCompleted = status == 'completed';
    final isNotStarted = status == 'not_started';
    final isInProgress = !isCompleted && !isNotStarted;
    final priorityColor = _getPriorityColor(item.priority);
    final progress = _itemProgress[item.id] ?? 0.0;

    final obstacleController = _obstacleControllers[item.id];
    final improvementController = _improvementControllers[item.id];

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCompleted
              ? Colors.green.withValues(alpha: 0.5)
              : AppColors.outlineVariant.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Header: Priority & Title
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: priorityColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    item.priority.toUpperCase(),
                    style: TextStyle(fontSize: 9, color: priorityColor, fontWeight: FontWeight.bold),
                  ),
                ),
                const Spacer(),
                if (isCompleted)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check, size: 12, color: Colors.green),
                        SizedBox(width: 4),
                        Text(
                          '100% SELESAI',
                          style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              item.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.onSurface),
            ),
            if (item.expectedOutput != null && item.expectedOutput!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                'Target: ${item.expectedOutput}',
                style: const TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant),
              ),
            ],
            const SizedBox(height: 12),

            // Status Selector Tabs
            Text(
              'Evaluasi Status:',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                _buildStatusChoice(item.id, 'completed', 'Selesai', Colors.green, Icons.check_circle_outline),
                const SizedBox(width: 6),
                _buildStatusChoice(item.id, 'in_progress', 'Berjalan', AppColors.primaryContainer, Icons.timelapse),
                const SizedBox(width: 6),
                _buildStatusChoice(item.id, 'not_started', 'Belum', AppColors.onSurfaceVariant, Icons.cancel_outlined),
              ],
            ),
            const SizedBox(height: 12),

            // Progress Slider
            if (isInProgress) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Capaian Progres:',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.onSurfaceVariant),
                  ),
                  Text(
                    '${progress.round()}%',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                ],
              ),
              Slider(
                value: progress.clamp(1.0, 99.0),
                min: 1,
                max: 99,
                divisions: 98,
                activeColor: AppColors.primary,
                onChanged: (val) {
                  setState(() {
                    _itemProgress[item.id] = val;
                  });
                },
              ),
            ] else if (isNotStarted) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Capaian Progres:',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.onSurfaceVariant),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.lock_outline, size: 11, color: AppColors.outline),
                        SizedBox(width: 4),
                        Text(
                          '0% (Belum Dimulai)',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  disabledThumbColor: AppColors.outlineVariant,
                  disabledActiveTrackColor: AppColors.outlineVariant.withValues(alpha: 0.4),
                  disabledInactiveTrackColor: AppColors.surfaceContainerLow,
                ),
                child: const Slider(
                  value: 0,
                  min: 0,
                  max: 100,
                  onChanged: null,
                ),
              ),
            ],

            // Input Fields based on rule
            if (isCompleted) ...[
              // Improvement Plan Field
              Text(
                'Rencana Perbaikan (Improvement Plan)',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800,
                ),
              ),
              const SizedBox(height: 4),
              if (improvementController != null)
                TextFormField(
                  controller: improvementController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: 'Misal: Mulai integrasi lebih awal di awal pekan agar testing lebih maksimal...',
                    hintStyle: const TextStyle(fontSize: 11),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
            ] else ...[
              // Obstacle Field
              Text(
                'Kendala yang Dihadapi (Obstacle)',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.error,
                ),
              ),
              const SizedBox(height: 4),
              if (obstacleController != null)
                TextFormField(
                  controller: obstacleController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: 'Misal: Menunggu konfirmasi aset dari tim desain atau akses kredensial gateway...',
                    hintStyle: const TextStyle(fontSize: 11),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChoice(
    int itemId,
    String value,
    String label,
    Color activeColor,
    IconData icon,
  ) {
    final isSelected = (_itemStatus[itemId] ?? '') == value;

    return Expanded(
      child: GestureDetector(
        onTap: () => _onStatusChanged(itemId, value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? activeColor.withValues(alpha: 0.15) : AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? activeColor : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14, color: isSelected ? activeColor : AppColors.outline),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? activeColor : AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.4)),
      ),
      child: const Column(
        children: [
          Icon(Icons.rate_review_outlined, size: 48, color: AppColors.outline),
          SizedBox(height: 12),
          Text(
            'Tidak Ada Item Evaluasi',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          SizedBox(height: 4),
          Text(
            'Belum ada aktivitas mingguan yang terdaftar pada pekan ini untuk dievaluasi.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
