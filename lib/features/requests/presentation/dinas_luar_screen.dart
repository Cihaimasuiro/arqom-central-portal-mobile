import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../../core/theme/app_colors.dart';
import '../data/models/request_models.dart';
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
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;
  File? _attachmentFile;
  String? _selectedFileName;
  bool _isLoading = false;

  // Metadata form options aligned with web portal
  String _tipeWaktu = 'harian'; // 'harian' | 'menginap'
  String _tipePeserta = 'individu'; // 'individu' | 'kelompok'
  List<EmployeeSimple> _availableEmployees = [];
  bool _loadingMeta = true;

  int? _selectedSingleEmployeeId;
  final Set<int> _selectedGroupEmployeeIds = {};

  @override
  void initState() {
    super.initState();
    _fetchMeta();
  }

  Future<void> _fetchMeta() async {
    final metaRes = await RequestsService.getRequestMeta();
    if (mounted) {
      setState(() {
        _loadingMeta = false;
        if (metaRes.success && metaRes.data != null) {
          _availableEmployees = metaRes.data!.employees;
          if (_availableEmployees.isNotEmpty) {
            _selectedSingleEmployeeId = _availableEmployees.first.id;
            _selectedGroupEmployeeIds.add(_availableEmployees.first.id);
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _locationController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String _formatDateYmd(DateTime dt) {
    return "${dt.year.toString().padLeft(4, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}";
  }

  Future<void> _selectTime(BuildContext context, TextEditingController controller) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final hours = picked.hour.toString().padLeft(2, '0');
      final minutes = picked.minute.toString().padLeft(2, '0');
      setState(() {
        controller.text = "$hours:$minutes";
      });
    }
  }

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) return;
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tanggal mulai dan selesai perjalanan dinas wajib diisi')),
      );
      return;
    }

    final selectedIds = <int>[];
    if (_tipePeserta == 'individu') {
      if (_selectedSingleEmployeeId != null) {
        selectedIds.add(_selectedSingleEmployeeId!);
      }
    } else {
      selectedIds.addAll(_selectedGroupEmployeeIds);
    }

    if (selectedIds.isEmpty && _availableEmployees.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih minimal satu pegawai peserta dinas')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final res = await RequestsService.createRequest(
      requestType: 'perjalanan_dinas',
      description: _descriptionController.text.trim(),
      startDate: _formatDateYmd(_startDate!),
      endDate: _formatDateYmd(_endDate!),
      startTime: _startTimeController.text.trim().isNotEmpty ? _startTimeController.text.trim() : null,
      endTime: _endTimeController.text.trim().isNotEmpty ? _endTimeController.text.trim() : null,
      location: _locationController.text.trim(),
      tipeWaktu: _tipeWaktu,
      tipePeserta: _tipePeserta,
      peserta: selectedIds.isNotEmpty ? selectedIds : null,
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
          'Pengajuan Perjalanan Dinas',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.surfaceContainerLowest,
        scrolledUnderElevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Notice banner
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.orange, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Perjalanan dinas memerlukan persetujuan berjenjang (Manager ➔ HCGA).',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.orange[800], fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Tipe Waktu (Harian / Menginap)
              Text('Tipe Waktu Dinas *', style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildChoiceChip(
                      label: 'Harian (PP)',
                      isSelected: _tipeWaktu == 'harian',
                      icon: Icons.today_rounded,
                      onTap: () => setState(() => _tipeWaktu = 'harian'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildChoiceChip(
                      label: 'Menginap',
                      isSelected: _tipeWaktu == 'menginap',
                      icon: Icons.hotel_rounded,
                      onTap: () => setState(() => _tipeWaktu = 'menginap'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Tipe Peserta (Individu / Kelompok)
              Text('Tipe Peserta *', style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildChoiceChip(
                      label: 'Individu',
                      isSelected: _tipePeserta == 'individu',
                      icon: Icons.person_rounded,
                      onTap: () => setState(() => _tipePeserta = 'individu'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildChoiceChip(
                      label: 'Kelompok (Tim)',
                      isSelected: _tipePeserta == 'kelompok',
                      icon: Icons.groups_rounded,
                      onTap: () => setState(() => _tipePeserta = 'kelompok'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Peserta Selection
              if (!_loadingMeta && _availableEmployees.isNotEmpty) ...[
                Text(
                  _tipePeserta == 'individu' ? 'Pegawai yang Ditugaskan *' : 'Daftar Pegawai yang Ditugaskan *',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                if (_tipePeserta == 'individu') ...[
                  DropdownButtonFormField<int>(
                    value: _selectedSingleEmployeeId,
                    isExpanded: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.surface,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.5))),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.5))),
                    ),
                    items: _availableEmployees
                        .map((emp) => DropdownMenuItem(
                              value: emp.id,
                              child: Text('${emp.name} (${emp.position})', style: const TextStyle(fontSize: 12)),
                            ))
                        .toList(),
                    onChanged: (val) => setState(() => _selectedSingleEmployeeId = val),
                  ),
                ] else ...[
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: _availableEmployees.map((emp) {
                      final isSelected = _selectedGroupEmployeeIds.contains(emp.id);
                      return FilterChip(
                        selected: isSelected,
                        label: Text(emp.name, style: TextStyle(fontSize: 11, color: isSelected ? Colors.white : AppColors.onSurface)),
                        selectedColor: AppColors.primary,
                        checkmarkColor: Colors.white,
                        backgroundColor: AppColors.surface,
                        onSelected: (val) {
                          setState(() {
                            if (val) {
                              _selectedGroupEmployeeIds.add(emp.id);
                            } else {
                              if (_selectedGroupEmployeeIds.length > 1) {
                                _selectedGroupEmployeeIds.remove(emp.id);
                              }
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
                const SizedBox(height: 18),
              ],

              // Lokasi / Kota Tujuan
              _buildInputField(
                'Alamat / Kota Tujuan Dinas',
                'Contoh: Yogyakarta / Kantor Cabang Solo',
                _locationController,
              ),
              const SizedBox(height: 18),

              // Tanggal Mulai & Tanggal Selesai
              Row(
                children: [
                  Expanded(
                    child: _buildDatePicker(
                      'Tgl Keberangkatan',
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
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildDatePicker(
                      'Tgl Kepulangan',
                      'Pilih tanggal',
                      _endDateController,
                      firstDate: _startDate,
                      onPicked: (dt) => _endDate = dt,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Jam Keberangkatan & Jam Kepulangan (Opsional)
              Row(
                children: [
                  Expanded(
                    child: _buildTimePicker('Jam Berangkat (Opsional)', _startTimeController),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildTimePicker('Jam Pulang (Opsional)', _endTimeController),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Deskripsi Keperluan
              _buildInputField(
                'Keperluan / Agenda Dinas',
                'Jelaskan agenda pertemuan atau tugas dinas luar',
                _descriptionController,
                maxLines: 3,
              ),
              const SizedBox(height: 18),

              // Lampiran
              Text(
                'Lampiran Bukti Tiket / Undangan (Opsional)',
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
                  padding: const EdgeInsets.all(16),
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
                        size: 24,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _selectedFileName ?? 'Unggah surat tugas / tiket (Maks 2MB)',
                          style: TextStyle(
                            fontSize: 11,
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
              const SizedBox(height: 30),

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
                    : const Text('Kirim Pengajuan Dinas', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChoiceChip({
    required String label,
    required bool isSelected,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.outlineVariant.withValues(alpha: 0.5),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: isSelected ? Colors.white : AppColors.onSurfaceVariant),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.onSurface,
              ),
            ),
          ],
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
            hintStyle: TextStyle(color: AppColors.onSurfaceVariant.withValues(alpha: 0.5), fontSize: 12),
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold)),
            Text(' *', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.error, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: true,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: AppColors.onSurfaceVariant.withValues(alpha: 0.5), fontSize: 11),
            suffixIcon: const Icon(Icons.calendar_month, color: AppColors.primary, size: 18),
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
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
          validator: (value) => value == null || value.isEmpty ? 'Wajib diisi' : null,
        ),
      ],
    );
  }

  Widget _buildTimePicker(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: true,
          decoration: InputDecoration(
            hintText: 'HH:mm',
            hintStyle: TextStyle(color: AppColors.onSurfaceVariant.withValues(alpha: 0.5), fontSize: 11),
            suffixIcon: const Icon(Icons.access_time, color: AppColors.primary, size: 18),
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.5))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.5))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary)),
          ),
          onTap: () => _selectTime(context, controller),
        ),
      ],
    );
  }
}
