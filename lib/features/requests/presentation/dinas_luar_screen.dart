import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../../core/theme/app_colors.dart';
import '../data/requests_service.dart';

class DinasLuarScreen extends StatefulWidget {
  const DinasLuarScreen({super.key});

  @override
  State<DinasLuarScreen> createState() => _DinasLuarScreenState();
}

class _DinasLuarScreenState extends State<DinasLuarScreen> {
  final _formKey = GlobalKey<FormState>();
  final _locationController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;
  File? _attachmentFile;
  String? _selectedFileName;
  bool _isLoading = false;

  @override
  void dispose() {
    _locationController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String _formatDateYmd(DateTime dt) {
    return "${dt.year.toString().padLeft(4, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}";
  }

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) return;
    if (_startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih tanggal mulai perjalanan dinas')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final res = await RequestsService.createRequest(
      requestType: 'perjalanan_dinas',
      description: _descriptionController.text.trim(),
      startDate: _formatDateYmd(_startDate!),
      endDate: _endDate != null ? _formatDateYmd(_endDate!) : null,
      location: _locationController.text.trim(),
      attachment: _attachmentFile,
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res.message),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLowest,
      appBar: AppBar(
        title: Text(
          'Pengajuan Dinas Luar',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.surfaceContainerLowest,
        scrolledUnderElevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.orange),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Dinas luar memerlukan persetujuan berjenjang (Manager ➔ HCGA) sebelum dianggap valid.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.orange[800]),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildInputField(
                'Tujuan Dinas / Lokasi',
                'Masukkan kota atau tempat tujuan',
                _locationController,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildDatePicker(
                      'Tanggal Mulai',
                      'Pilih tanggal',
                      _startDateController,
                      onPicked: (dt) {
                        _startDate = dt;
                        if (_endDate != null && _endDate!.isBefore(dt)) {
                          _endDate = dt;
                          _endDateController.text = _formatDateYmd(dt);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDatePicker(
                      'Tanggal Selesai',
                      'Pilih tanggal',
                      _endDateController,
                      firstDate: _startDate,
                      onPicked: (dt) => _endDate = dt,
                      required: false,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildInputField(
                'Keperluan / Catatan Dinas',
                'Jelaskan agenda dan keperluan dinas luar',
                _descriptionController,
                maxLines: 4,
              ),
              const SizedBox(height: 20),
              Text(
                'Lampiran Surat Tugas / Tiket (Opsional)',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () async {
                  FilePickerResult? result = await FilePicker.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['jpg', 'pdf', 'png'],
                  );

                  if (result != null && result.files.single.path != null) {
                    setState(() {
                      _selectedFileName = result.files.single.name;
                      _attachmentFile = File(result.files.single.path!);
                    });
                  }
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: _selectedFileName != null ? AppColors.primary.withValues(alpha: 0.05) : AppColors.surface,
                    border: Border.all(
                      color: _selectedFileName != null ? AppColors.primary : AppColors.outlineVariant.withValues(alpha: 0.5),
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _selectedFileName != null ? Icons.check_circle : Icons.upload_file,
                        color: AppColors.primary,
                        size: 26,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _selectedFileName ?? 'Unggah dokumen pendukung / tiket (Maks 2MB)',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: _selectedFileName != null ? FontWeight.bold : FontWeight.normal,
                            color: _selectedFileName != null ? AppColors.primary : AppColors.onSurfaceVariant,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
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
                    : const Text('Kirim Pengajuan', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
    String label,
    String hint,
    TextEditingController controller, {
    int maxLines = 1,
    bool required = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold)),
            if (required)
              Text(' *', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.error, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: AppColors.onSurfaceVariant.withValues(alpha: 0.5)),
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.5))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.5))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary)),
          ),
          validator: required ? (value) => value == null || value.trim().isEmpty ? 'Wajib diisi' : null : null,
        ),
      ],
    );
  }

  Widget _buildDatePicker(
    String label,
    String hint,
    TextEditingController controller, {
    DateTime? firstDate,
    required Function(DateTime) onPicked,
    bool required = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold)),
            if (required)
              Text(' *', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.error, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: true,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: AppColors.onSurfaceVariant.withValues(alpha: 0.5)),
            suffixIcon: const Icon(Icons.calendar_month, color: AppColors.primary),
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.5))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.5))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary)),
          ),
          onTap: () async {
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: firstDate ?? DateTime.now(),
              firstDate: firstDate ?? DateTime.now().subtract(const Duration(days: 7)),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (pickedDate != null) {
              setState(() {
                controller.text = _formatDateYmd(pickedDate);
                onPicked(pickedDate);
              });
            }
          },
          validator: required ? (value) => value == null || value.isEmpty ? 'Wajib diisi' : null : null,
        ),
      ],
    );
  }
}
