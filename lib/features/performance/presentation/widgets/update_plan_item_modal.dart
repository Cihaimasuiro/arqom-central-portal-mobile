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
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _expectedOutputController;
  late TextEditingController _targetDateController;
  late TextEditingController _detailsController;

  late String _priority;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.item.title);
    _expectedOutputController = TextEditingController(text: widget.item.expectedOutput ?? '');
    _targetDateController = TextEditingController(text: widget.item.targetDate ?? '');
    _detailsController = TextEditingController(text: widget.item.details ?? '');
    _priority = widget.item.priority;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _expectedOutputController.dispose();
    _targetDateController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    DateTime initial = now;
    if (_targetDateController.text.isNotEmpty) {
      final parsed = DateTime.tryParse(_targetDateController.text);
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
        _targetDateController.text = formatted;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final body = <String, dynamic>{
        'title': _titleController.text.trim(),
        'expected_output': _expectedOutputController.text.trim(),
        'priority': _priority,
      };

      if (_targetDateController.text.trim().isNotEmpty) {
        body['target_date'] = _targetDateController.text.trim();
      }

      if (_detailsController.text.trim().isNotEmpty) {
        body['details'] = _detailsController.text.trim();
      }

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
        maxHeight: MediaQuery.of(context).size.height * 0.88,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Edit Rincian Rencana',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Pembaruan judul, output, prioritas & tanggal target',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant, fontSize: 10),
                        ),
                      ],
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

              // Monthly Target Badge if connected
              if (widget.item.monthlyTargetTitle != null) ...[
                Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.link, size: 16, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Target Bulanan: ${widget.item.monthlyTargetTitle}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // Info Banner: Progres diupdate di Weekly Review
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline, size: 15, color: AppColors.outline),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Progres pengerjaan dan status evaluasi dilakukan terpusat pada Menu 3: Weekly Review setiap akhir pekan (Jumat).',
                        style: TextStyle(fontSize: 10.5, color: AppColors.outline, height: 1.3),
                      ),
                    ),
                  ],
                ),
              ),

              // Title Field
              Text(
                'Judul Rencana',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Misal: Slicing UI Weekly Review & Integrasi API Mobile',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Judul rencana tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),

              // Expected Output
              Text(
                'Target Output (Expected Output)',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _expectedOutputController,
                decoration: InputDecoration(
                  hintText: 'Misal: Layar Weekly Review selesai & terintegrasi',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 14),

              // Prioritas
              Text(
                'Prioritas',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: _priority,
                isExpanded: true,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
              const SizedBox(height: 14),

              // Target Tanggal
              Text(
                'Target Tanggal',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _targetDateController,
                readOnly: true,
                onTap: _pickDate,
                decoration: InputDecoration(
                  hintText: 'YYYY-MM-DD',
                  suffixIcon: const Icon(Icons.event, size: 18),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 14),

              // Details
              Text(
                'Keterangan / Rincian Tambahan',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _detailsController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'Misal: Menyelesaikan implementasi handling offline...',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 22),

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
                        'Simpan Rincian Rencana',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
