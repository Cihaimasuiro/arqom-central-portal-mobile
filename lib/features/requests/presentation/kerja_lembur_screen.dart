import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../data/models/request_models.dart';
import '../data/requests_service.dart';
import 'widgets/request_error_dialog.dart';

class KerjaLemburScreen extends StatefulWidget {
  final RequestItem? existingItem;

  const KerjaLemburScreen({super.key, this.existingItem});

  @override
  State<KerjaLemburScreen> createState() => _KerjaLemburScreenState();
}

class _KerjaLemburScreenState extends State<KerjaLemburScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();
  final _targetController = TextEditingController();
  final _noteController = TextEditingController();

  DateTime? _selectedDate;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkRoleAccess();
    if (widget.existingItem != null) {
      final item = widget.existingItem!;
      _dateController.text = item.startDate;
      _selectedDate = DateTime.tryParse(item.startDate);
      _startTimeController.text = item.startTime ?? '';
      _endTimeController.text = item.endTime ?? '';
      _targetController.text = item.description;
    }
  }

  Future<void> _checkRoleAccess() async {
    final metaRes = await RequestsService.getRequestMeta();
    if (mounted && metaRes.success && metaRes.data != null && !metaRes.data!.canUseElevatedTypes) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.gpp_bad_outlined, color: AppColors.error, size: 24),
              SizedBox(width: 8),
              Text('Akses Ditolak (403)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          content: const Text(
            'Pengajuan Kerja Lembur hanya dapat dibuat oleh akun minimal level Head (Head, Lead, Manager, Direktur).',
            style: TextStyle(fontSize: 13),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Kembali'),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _targetController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  String _formatDateYmd(DateTime dt) {
    return "${dt.year.toString().padLeft(4, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}";
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 14)),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = _formatDateYmd(picked);
      });
    }
  }

  Future<void> _selectTime(BuildContext context, TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        final hours = picked.hour.toString().padLeft(2, '0');
        final minutes = picked.minute.toString().padLeft(2, '0');
        controller.text = "$hours:$minutes";
      });
    }
  }

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih tanggal lembur')),
      );
      return;
    }

    setState(() => _isLoading = true);

    String desc = _targetController.text.trim();
    if (_noteController.text.trim().isNotEmpty) {
      desc += ' (Catatan: ${_noteController.text.trim()})';
    }

    final isEdit = widget.existingItem != null;
    final res = isEdit
        ? await RequestsService.updateRequest(
            id: widget.existingItem!.id,
            requestType: 'lembur',
            description: desc,
            startDate: _formatDateYmd(_selectedDate!),
            startTime: _startTimeController.text.trim(),
            endTime: _endTimeController.text.trim(),
          )
        : await RequestsService.createRequest(
            requestType: 'lembur',
            description: desc,
            startDate: _formatDateYmd(_selectedDate!),
            startTime: _startTimeController.text.trim(),
            endTime: _endTimeController.text.trim(),
          );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (res.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res.message),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true);
    } else {
      handleRequestApiError(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLowest,
      appBar: AppBar(
        title: Text(widget.existingItem != null ? 'Edit Pengajuan Kerja Lembur' : 'Pengajuan Kerja Lembur', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.onSurface,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Waktu Pelaksanaan'),
                    const SizedBox(height: 16),
                    _buildDatePicker('Tanggal Lembur', 'Pilih tanggal', _dateController),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(child: _buildTimePicker('Jam Mulai', 'Contoh: 17:30', _startTimeController)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildTimePicker('Jam Selesai', 'Contoh: 21:00', _endTimeController)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Detail Pekerjaan'),
                    const SizedBox(height: 16),
                    _buildInputField(
                      'Target / Pekerjaan',
                      'Tuliskan target yang akan diselesaikan saat lembur',
                      _targetController,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 20),
                    _buildInputField(
                      'Keterangan Tambahan',
                      'Catatan opsional',
                      _noteController,
                      maxLines: 3,
                      isRequired: false,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: _isLoading ? null : _submitRequest,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
          child: _isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
              : Text(widget.existingItem != null ? 'Simpan Perubahan' : 'Kirim Pengajuan', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
    );
  }

  Widget _buildDatePicker(String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: true,
          onTap: () => _selectDate(context),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: AppColors.onSurfaceVariant.withValues(alpha: 0.5)),
            suffixIcon: const Icon(Icons.calendar_today, color: AppColors.primary, size: 20),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.5))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.5))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            filled: true,
            fillColor: AppColors.surface,
          ),
          validator: (value) => value == null || value.isEmpty ? 'Wajib diisi' : null,
        ),
      ],
    );
  }

  Widget _buildTimePicker(String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: true,
          onTap: () => _selectTime(context, controller),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: AppColors.onSurfaceVariant.withValues(alpha: 0.5)),
            suffixIcon: const Icon(Icons.access_time, color: AppColors.primary, size: 20),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.5))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.5))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            filled: true,
            fillColor: AppColors.surface,
          ),
          validator: (value) => value == null || value.isEmpty ? 'Wajib diisi' : null,
        ),
      ],
    );
  }

  Widget _buildInputField(
    String label,
    String hint,
    TextEditingController controller, {
    int maxLines = 1,
    bool isRequired = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold)),
            if (!isRequired) Text(' (Opsional)', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant)),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: AppColors.onSurfaceVariant.withValues(alpha: 0.5)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.5))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.5))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            filled: true,
            fillColor: AppColors.surface,
          ),
          validator: isRequired ? (value) => value == null || value.trim().isEmpty ? 'Wajib diisi' : null : null,
        ),
      ],
    );
  }
}
