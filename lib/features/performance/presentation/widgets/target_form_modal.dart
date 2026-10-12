import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/performance_models.dart';
import '../../data/performance_service.dart';

class TargetFormModal extends StatefulWidget {
  final int currentYear;
  final String currentPeriod;
  final List<MonthlyTargetItem> availableParents;
  final MonthlyTargetItem? initialTarget; // If editing
  final String? preselectedLevel;
  final int? preselectedParentId;
  final VoidCallback onSuccess;

  const TargetFormModal({
    super.key,
    required this.currentYear,
    required this.currentPeriod,
    this.availableParents = const [],
    this.initialTarget,
    this.preselectedLevel,
    this.preselectedParentId,
    required this.onSuccess,
  });

  @override
  State<TargetFormModal> createState() => _TargetFormModalState();
}

class _TargetFormModalState extends State<TargetFormModal> {
  final _formKey = GlobalKey<FormState>();

  late String _level;
  late String _priority;
  late String _status;
  int? _parentId;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _expectedResultsController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();

  bool _isLoading = false;

  bool get _isEdit => widget.initialTarget != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      final t = widget.initialTarget!;
      _level = t.level;
      _priority = t.priority;
      _status = t.status;
      _parentId = t.parentId;
      _titleController.text = t.title;
      _expectedResultsController.text = t.expectedResults ?? '';
      _notesController.text = t.notes ?? '';
      _startDateController.text = t.startDate ?? '';
      _deadlineController.text = t.deadline ?? '';
    } else {
      _level = widget.preselectedLevel ?? 'main';
      _priority = 'normal';
      _status = 'not_started';
      _parentId = widget.preselectedParentId;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _expectedResultsController.dispose();
    _notesController.dispose();
    _startDateController.dispose();
    _deadlineController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(TextEditingController controller) async {
    final now = DateTime.now();
    DateTime initial = now;
    if (controller.text.isNotEmpty) {
      final parsed = DateTime.tryParse(controller.text);
      if (parsed != null) initial = parsed;
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
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
      final formatted =
          "${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      setState(() {
        controller.text = formatted;
      });
    }
  }

  List<MonthlyTargetItem> _getSelectableParents() {
    if (_level == 'weekly') {
      // Parents must be main level
      return widget.availableParents.where((t) => t.level == 'main').toList();
    } else if (_level == 'daily') {
      // Parents must be weekly level
      List<MonthlyTargetItem> weeklies = [];
      for (final main in widget.availableParents) {
        for (final w in main.children) {
          if (w.level == 'weekly') {
            weeklies.add(w);
          }
        }
      }
      return weeklies;
    }
    return [];
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_isEdit && _level != 'main' && _parentId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih target induk (parent) terlebih dahulu.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (_isEdit) {
        final body = <String, dynamic>{
          'title': _titleController.text.trim(),
          'expected_results': _expectedResultsController.text.trim(),
          'status': _status,
          'priority': _priority,
          'notes': _notesController.text.trim(),
        };
        if (_startDateController.text.isNotEmpty) {
          body['start_date'] = _startDateController.text;
        }
        if (_deadlineController.text.isNotEmpty) {
          body['deadline'] = _deadlineController.text;
        }

        final res = await PerformanceService.updateMonthlyTarget(
          widget.initialTarget!.id,
          body,
        );

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
      } else {
        final body = <String, dynamic>{
          'year': widget.currentYear,
          'period': widget.currentPeriod,
          'level': _level,
          'title': _titleController.text.trim(),
          'expected_results': _expectedResultsController.text.trim(),
          'priority': _priority,
          'status': _status,
          'notes': _notesController.text.trim(),
        };
        if (_startDateController.text.isNotEmpty) {
          body['start_date'] = _startDateController.text;
        }
        if (_deadlineController.text.isNotEmpty) {
          body['deadline'] = _deadlineController.text;
        }
        if (_parentId != null) {
          body['parent_id'] = _parentId;
        }

        final res = await PerformanceService.createMonthlyTarget(body);

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
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final selectableParents = _getSelectableParents();

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
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
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _isEdit ? 'Ubah Target' : 'Tambah Target Baru',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
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

              // Level Selector (Only when creating)
              if (!_isEdit) ...[
                Text(
                  'Tingkatan Target',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildLevelOption('main', 'Main (Utama)'),
                    const SizedBox(width: 8),
                    _buildLevelOption('weekly', 'Weekly (Pekan)'),
                    const SizedBox(width: 8),
                    _buildLevelOption('daily', 'Daily (Harian)'),
                  ],
                ),
                const SizedBox(height: 16),
              ],

              // Parent Selector (if weekly or daily)
              if (!_isEdit && _level != 'main') ...[
                Text(
                  _level == 'weekly' ? 'Target Utama Induk' : 'Target Pekanan Induk',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<int>(
                  value: _parentId,
                  isExpanded: true,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    hintText: 'Pilih target induk...',
                  ),
                  items: selectableParents.map((p) {
                    return DropdownMenuItem<int>(
                      value: p.id,
                      child: Text(
                        p.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 13),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _parentId = val;
                    });
                  },
                  validator: (val) {
                    if (val == null) return 'Wajib memilih target induk';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
              ],

              // Title Field
              Text(
                'Judul Target',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Misal: Optimalisasi Performa Database Portal',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Judul target tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Expected Results
              Text(
                'Hasil yang Diharapkan (Expected Results)',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _expectedResultsController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'Misal: Query response time di bawah 100ms',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),

              // Priority & Status Row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Prioritas',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          value: _priority,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'low', child: Text('Rendah (Low)')),
                            DropdownMenuItem(value: 'normal', child: Text('Normal')),
                            DropdownMenuItem(value: 'high', child: Text('Tinggi (High)')),
                            DropdownMenuItem(value: 'urgent', child: Text('Mendesak')),
                          ],
                          onChanged: (val) {
                            if (val != null) setState(() => _priority = val);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Status',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          value: _status,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'not_started', child: Text('Belum Mulai')),
                            DropdownMenuItem(value: 'in_progress', child: Text('Sedang Berjalan')),
                            DropdownMenuItem(value: 'completed', child: Text('Selesai')),
                          ],
                          onChanged: (val) {
                            if (val != null) setState(() => _status = val);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Dates Row
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tanggal Mulai',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _startDateController,
                          readOnly: true,
                          onTap: () => _pickDate(_startDateController),
                          decoration: InputDecoration(
                            hintText: 'YYYY-MM-DD',
                            suffixIcon: const Icon(Icons.calendar_today, size: 18),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tenggat (Deadline)',
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _deadlineController,
                          readOnly: true,
                          onTap: () => _pickDate(_deadlineController),
                          decoration: InputDecoration(
                            hintText: 'YYYY-MM-DD',
                            suffixIcon: const Icon(Icons.event, size: 18),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Notes Field
              Text(
                'Catatan (Opsional)',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _notesController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'Fokus pengerjaan, dependensi, atau detail lain...',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 24),

              // Submit Button
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
                    : Text(
                        _isEdit ? 'Simpan Perubahan' : 'Tambah Target',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLevelOption(String value, String label) {
    final isSelected = _level == value;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _level = value;
            _parentId = null;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryContainer.withValues(alpha: 0.15) : AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Center(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
