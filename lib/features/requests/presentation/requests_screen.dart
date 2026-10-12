import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../data/models/request_models.dart';
import '../data/requests_service.dart';
import 'cuti_tahunan_screen.dart';
import 'izin_sakit_screen.dart';
import 'dinas_luar_screen.dart';
import 'kerja_lembur_screen.dart';
import 'reimburse_screen.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  int _selectedMainTab = 0; // 0: Pengajuan Saya, 1: Perlu Persetujuan (Inbox Atasan)
  String _selectedStatusFilter = 'Semua';

  bool _isLoading = true;
  String? _errorMessage;

  List<RequestItem> _myRequests = [];
  List<RequestItem> _pendingApprovals = [];

  final List<String> _statusFilters = [
    'Semua',
    'Menunggu Manager',
    'Menunggu HCGA',
    'Disetujui',
    'Ditolak',
    'Dibatalkan',
  ];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData({bool silent = false}) async {
    if (!silent) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final myReqRes = await RequestsService.getRequests(
        status: _selectedStatusFilter == 'Semua' ? null : _selectedStatusFilter,
      );
      final approvalsRes = await RequestsService.getApprovals();

      if (mounted) {
        setState(() {
          _isLoading = false;
          if (myReqRes.success && myReqRes.data != null) {
            _myRequests = myReqRes.data!;
          } else {
            _errorMessage = myReqRes.message;
          }

          if (approvalsRes.success && approvalsRes.data != null) {
            _pendingApprovals = approvalsRes.data!;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Gagal memuat data: $e';
        });
      }
    }
  }

  Future<void> _handleCancelRequest(RequestItem item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Batalkan Pengajuan?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: Text('Apakah Anda yakin ingin membatalkan pengajuan "${item.title}" (${item.requestNumber})?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Tidak'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Ya, Batalkan'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final res = await RequestsService.cancelRequest(item.id);
      if (!mounted) return;
      if (res.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res.message), backgroundColor: Colors.green),
        );
        _fetchData(silent: true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res.message), backgroundColor: AppColors.error),
        );
      }
    }
  }

  Future<void> _handleApprove(RequestItem item) async {
    final noteController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.green, size: 24),
            const SizedBox(width: 8),
            const Text('Setujui Pengajuan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Setujui pengajuan ${item.typeLabel} dari ${item.employee?.name ?? "karyawan"}?'),
            const SizedBox(height: 12),
            TextField(
              controller: noteController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'Catatan persetujuan (opsional)...',
                hintStyle: const TextStyle(fontSize: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('Setujui'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final res = await RequestsService.approveRequest(item.id, note: noteController.text.trim());
      if (!mounted) return;
      if (res.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res.message), backgroundColor: Colors.green),
        );
        _fetchData(silent: true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res.message), backgroundColor: AppColors.error),
        );
      }
    }
  }

  Future<void> _handleReject(RequestItem item) async {
    final noteController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.cancel_outlined, color: AppColors.error, size: 24),
            const SizedBox(width: 8),
            const Text('Tolak Pengajuan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tolak pengajuan ${item.typeLabel} dari ${item.employee?.name ?? "karyawan"}?'),
            const SizedBox(height: 12),
            TextField(
              controller: noteController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'Alasan penolakan (wajib diisi)...',
                hintStyle: const TextStyle(fontSize: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              if (noteController.text.trim().isEmpty) {
                ScaffoldMessenger.of(ctx).showSnackBar(
                  const SnackBar(content: Text('Alasan penolakan wajib diisi')),
                );
                return;
              }
              Navigator.pop(ctx, true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Tolak'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final res = await RequestsService.rejectRequest(item.id, note: noteController.text.trim());
      if (!mounted) return;
      if (res.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res.message), backgroundColor: Colors.orange.shade800),
        );
        _fetchData(silent: true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res.message), backgroundColor: AppColors.error),
        );
      }
    }
  }

  Future<void> _openForm(Widget screen) async {
    final created = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
    if (created == true) {
      _fetchData(silent: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLowest,
      body: RefreshIndicator(
        color: AppColors.primary,
        backgroundColor: AppColors.surface,
        onRefresh: () => _fetchData(silent: true),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildMiniHeader(context),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildQuickCategories(context),
                    const SizedBox(height: 20),
                    _buildMainTabSelector(),
                    const SizedBox(height: 16),
                    if (_selectedMainTab == 0) ...[
                      _buildStatusFilters(context),
                      const SizedBox(height: 14),
                      _buildMyRequestsList(),
                    ] else ...[
                      _buildApprovalsList(),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiniHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 20,
        right: 20,
        bottom: 22,
      ),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pengajuan & Izin',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.verified_user_outlined, color: Colors.white, size: 13),
                    SizedBox(width: 4),
                    Text(
                      'Persetujuan Berjenjang',
                      style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Kelola cuti, izin, sakit, lembur, dan dinas luar',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white70, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildMainTabSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedMainTab = 0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: _selectedMainTab == 0 ? AppColors.surface : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: _selectedMainTab == 0
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.history_rounded,
                      size: 16,
                      color: _selectedMainTab == 0 ? AppColors.primary : AppColors.onSurfaceVariant,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Pengajuan Saya',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: _selectedMainTab == 0 ? FontWeight.bold : FontWeight.w500,
                        color: _selectedMainTab == 0 ? AppColors.primary : AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedMainTab = 1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: _selectedMainTab == 1 ? AppColors.surface : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: _selectedMainTab == 1
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inbox_rounded,
                      size: 16,
                      color: _selectedMainTab == 1 ? AppColors.primary : AppColors.onSurfaceVariant,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Perlu Persetujuan',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: _selectedMainTab == 1 ? FontWeight.bold : FontWeight.w500,
                        color: _selectedMainTab == 1 ? AppColors.primary : AppColors.onSurfaceVariant,
                      ),
                    ),
                    if (_pendingApprovals.isNotEmpty) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${_pendingApprovals.length}',
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickCategories(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Buat Pengajuan Baru',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.95,
          children: [
            _buildCategoryButton(
              context,
              'Cuti Tahunan',
              Icons.beach_access_rounded,
              AppColors.primaryContainer.withValues(alpha: 0.4),
              AppColors.primary,
              onTap: () => _openForm(const CutiTahunanScreen()),
            ),
            _buildCategoryButton(
              context,
              'Sakit & Izin',
              Icons.medical_services_rounded,
              AppColors.errorContainer.withValues(alpha: 0.4),
              AppColors.error,
              onTap: () => _openForm(const IzinSakitScreen()),
            ),
            _buildCategoryButton(
              context,
              'Dinas Luar',
              Icons.flight_takeoff_rounded,
              AppColors.tertiaryContainer.withValues(alpha: 0.4),
              AppColors.tertiary,
              onTap: () => _openForm(const DinasLuarScreen()),
            ),
            _buildCategoryButton(
              context,
              'Kerja Lembur',
              Icons.access_time_filled_rounded,
              Colors.indigo.withValues(alpha: 0.12),
              Colors.indigo,
              onTap: () => _openForm(const KerjaLemburScreen()),
            ),
            _buildCategoryButton(
              context,
              'Reimburse',
              Icons.receipt_long_rounded,
              AppColors.secondaryContainer.withValues(alpha: 0.4),
              AppColors.secondary,
              onTap: () => _openForm(const ReimburseScreen()),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryButton(
    BuildContext context,
    String label,
    IconData icon,
    Color bgColor,
    Color iconColor, {
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusFilters(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _statusFilters.map((filter) {
          final isActive = _selectedStatusFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedStatusFilter = filter);
                _fetchData();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary : AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isActive ? AppColors.primary : AppColors.outlineVariant.withValues(alpha: 0.5),
                  ),
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                    color: isActive ? Colors.white : AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMyRequestsList() {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (_errorMessage != null && _myRequests.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.4)),
        ),
        child: Column(
          children: [
            const Icon(Icons.cloud_off, size: 40, color: AppColors.error),
            const SizedBox(height: 10),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: AppColors.error),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => _fetchData(),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    if (_myRequests.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.4)),
        ),
        child: Column(
          children: [
            const Icon(Icons.folder_open_rounded, size: 44, color: AppColors.outline),
            const SizedBox(height: 10),
            const Text('Belum Ada Pengajuan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 4),
            Text(
              _selectedStatusFilter == 'Semua'
                  ? 'Anda belum pernah membuat permohonan ketidakhadiran atau tugas khusus.'
                  : 'Tidak ada pengajuan dengan status "$_selectedStatusFilter".',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant),
            ),
          ],
        ),
      );
    }

    return Column(
      children: _myRequests.map((item) => _buildMyRequestCard(item)).toList(),
    );
  }

  Widget _buildMyRequestCard(RequestItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top: Icon, Title & Status Badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: item.typeColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(item.typeIcon, color: item.typeColor, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.typeLabel,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      Text(
                        item.requestNumber,
                        style: const TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: item.statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item.status,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: item.statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Date & Detail Box
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, size: 13, color: AppColors.primary),
                      const SizedBox(width: 6),
                      Text(
                        item.endDate != null && item.endDate != item.startDate
                            ? '${item.startDate} s/d ${item.endDate}'
                            : item.startDate,
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                      if (item.startTime != null && item.endTime != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          '(${item.startTime} - ${item.endTime})',
                          style: const TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant),
                        ),
                      ],
                    ],
                  ),
                  if (item.location != null && item.location!.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 13, color: AppColors.tertiary),
                        const SizedBox(width: 6),
                        Text(
                          item.location!,
                          style: const TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 6),
                  Text(
                    item.description,
                    style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: AppColors.onSurface),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Approval Flow Steps
            _buildApprovalTimeline(item),

            // Cancel Action Button
            if (item.canCancel) ...[
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () => _handleCancelRequest(item),
                  icon: const Icon(Icons.cancel_outlined, size: 14, color: AppColors.error),
                  label: const Text('Batalkan Pengajuan', style: TextStyle(fontSize: 11, color: AppColors.error)),
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildApprovalTimeline(RequestItem item) {
    final managerStatus = item.managerApproval?.status ?? 'Menunggu';
    final hcgaStatus = item.hcgaApproval?.status ?? 'Menunggu';

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ALUR PERSETUJUAN BERJENJANG',
            style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.8, color: AppColors.outline),
          ),
          const SizedBox(height: 8),
          _buildTimelineRow(
            '1. Atasan Langsung / Manager',
            managerStatus,
            item.managerApproval?.note,
            item.managerApproval?.approvedBy,
          ),
          const Divider(height: 12, thickness: 0.5),
          _buildTimelineRow(
            '2. HCGA / HR Operations',
            hcgaStatus,
            item.hcgaApproval?.note,
            item.hcgaApproval?.approvedBy,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineRow(String role, String status, String? note, String? approver) {
    Color color;
    IconData icon;
    if (status.toLowerCase().contains('setuju')) {
      color = Colors.green;
      icon = Icons.check_circle;
    } else if (status.toLowerCase().contains('tolak')) {
      color = AppColors.error;
      icon = Icons.cancel;
    } else {
      color = AppColors.outline;
      icon = Icons.schedule;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(role, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  Text(status, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color)),
                ],
              ),
              if (approver != null && approver.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text('Oleh: $approver', style: const TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant)),
              ],
              if (note != null && note.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text('"$note"', style: const TextStyle(fontSize: 10, fontStyle: FontStyle.italic, color: AppColors.onSurfaceVariant)),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildApprovalsList() {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (_pendingApprovals.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.4)),
        ),
        child: const Column(
          children: [
            Icon(Icons.inbox_outlined, size: 44, color: AppColors.outline),
            SizedBox(height: 10),
            Text('Semua Pengajuan Selesai', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            SizedBox(height: 4),
            Text(
              'Tidak ada permohonan staf yang memerlukan persetujuan Anda saat ini.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant),
            ),
          ],
        ),
      );
    }

    return Column(
      children: _pendingApprovals.map((item) => _buildApprovalCard(item)).toList(),
    );
  }

  Widget _buildApprovalCard(RequestItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Employee Info Header
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColors.primaryContainer,
                  child: Text(
                    (item.employee?.name.isNotEmpty == true) ? item.employee!.name[0].toUpperCase() : 'E',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.employee?.name ?? 'Nama Karyawan',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      Text(
                        '${item.employee?.position ?? "-"} • ${item.employee?.division ?? "-"}',
                        style: const TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: item.typeColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item.typeLabel,
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: item.typeColor),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Date & Reason Details
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_month, size: 13, color: AppColors.primary),
                      const SizedBox(width: 6),
                      Text(
                        item.endDate != null && item.endDate != item.startDate
                            ? '${item.startDate} s/d ${item.endDate}'
                            : item.startDate,
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.description,
                    style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Approve & Reject Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _handleReject(item),
                    icon: const Icon(Icons.close, size: 16, color: AppColors.error),
                    label: const Text('Tolak', style: TextStyle(color: AppColors.error, fontSize: 12)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.error),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _handleApprove(item),
                    icon: const Icon(Icons.check, size: 16, color: Colors.white),
                    label: const Text('Setujui', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
