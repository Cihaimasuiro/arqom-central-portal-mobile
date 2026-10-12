import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/performance_models.dart';
import '../../data/performance_service.dart';

class UpdatePlanItemModal extends StatefulWidget {
  final WeeklyPlanItem item;
  final VoidCallback onSuccess;

  const UpdatePlanItemModal({
    super.key,
    required this.item,
    required this.onSuccess,
  });

  @override
  State<UpdatePlanItemModal> createState() => _UpdatePlanItemModalState();
}

class _UpdatePlanItemModalState extends State<UpdatePlanItemModal> {
  late String _status;
  late double _progress;
  final TextEditingController _detailsController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _status = widget.item.executionStatus;
    _progress = widget.item.progressPercent.toDouble().clamp(0.0, 100.0);
    _detailsController.text = widget.item.details ?? '';
  }

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  void _onStatusChanged(String? newStatus) {
    if (newStatus == null) return;
    setState(() {
      _status = newStatus;
      if (newStatus == 'completed') {
        _progress = 100.0;
      } else if (newStatus == 'not_started' && _progress == 100.0) {
        _progress = 0.0;
      }
    });
  }

  Future<void> _submit() async {
    setState(() => _isLoading = true);

    try {
      final body = <String, dynamic>{
        'execution_status': _status,
        'progress_percent': _progress.round(),
        'details': _detailsController.text.trim(),
      };

      final res = await PerformanceService.updateWeeklyPlanItem(widget.item.id, body);

      if (!mounted) return;
      if (res.success) {
        Navigator.pop(context);
        widget.onSuccess();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res.message),
            backgroundColor: AppColors.secondary,
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
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: bottomInset + 20,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Update Progres & Rincian',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.onSurfaceVariant),
                  onPressed: () => Navigator.pop(context),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            const Divider(height: 20),

            // Item Title Display
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.item.monthlyTargetTitle != null) ...[
                    Text(
                      'Target Bulanan: ${widget.item.monthlyTargetTitle}',
                      style: const TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                  ],
                  Text(
                    widget.item.title,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  if (widget.item.expectedOutput != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Output: ${widget.item.expectedOutput}',
                      style: const TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Status Dropdown
            Text(
              'Status Eksekusi',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: _status,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items: const [
                DropdownMenuItem(value: 'not_started', child: Text('Belum Mulai (Not Started)')),
                DropdownMenuItem(value: 'in_progress', child: Text('Sedang Berjalan (In Progress)')),
                DropdownMenuItem(value: 'completed', child: Text('Selesai (Completed)')),
              ],
              onChanged: _onStatusChanged,
            ),
            const SizedBox(height: 16),

            // Progress Slider
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Persentase Progres',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${_progress.round()}%',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Slider(
              value: _progress,
              min: 0,
              max: 100,
              divisions: 20,
              activeColor: AppColors.primary,
              onChanged: _status == 'completed'
                  ? null
                  : (val) {
                      setState(() {
                        _progress = val;
                      });
                    },
            ),
            if (_status == 'completed')
              const Padding(
                padding: EdgeInsets.only(left: 4, bottom: 8),
                child: Text(
                  'Status selesai otomatis mengatur progres menjadi 100%.',
                  style: TextStyle(fontSize: 10, color: Colors.green, fontStyle: FontStyle.italic),
                ),
              ),
            const SizedBox(height: 12),

            // Details
            Text(
              'Rincian / Catatan Pengerjaan (Details)',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            TextFormField(
              controller: _detailsController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Misal: Menyelesaikan implementasi handling offline mode...',
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _isLoading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Text(
                      'Simpan Pembaruan',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
