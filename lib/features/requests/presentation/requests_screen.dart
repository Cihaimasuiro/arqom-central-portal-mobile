import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../core/theme/app_colors.dart';
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
  bool _isRefreshingOverlay = false;

  Future<void> _refreshData() async {
    setState(() {
      _isRefreshingOverlay = true;
    });
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        _isRefreshingOverlay = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLowest,
      body: Stack(
        children: [
          RefreshIndicator(
            color: Colors.transparent,
            backgroundColor: Colors.transparent,
            elevation: 0,
            onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildMiniHeader(context),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildQuotaSummary(context),
                  const SizedBox(height: 20),
                  _buildQuickCategories(context),
                  const SizedBox(height: 20),
                  _buildSectionHeader(context, 'Daftar Pengajuan', 'Riwayat pengajuan Anda'),
                  const SizedBox(height: 12),
                  _buildStatusFilters(context),
                  const SizedBox(height: 12),
                  _buildRequestList(context),
                  const SizedBox(height: 20),
                  _buildHelpCard(context),
                ],
              ),
            ),
          ],
        ),
      ),
      ),
      if (_isRefreshingOverlay)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  color: Colors.black.withValues(alpha: 0.1),
                  child: const Center(
                    child: SpinKitFadingCube(color: AppColors.primary, size: 50.0),
                  ),
                ),
              ),
            ),
        ],
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
        bottom: 24,
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
                'Pengajuan',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              IconButton(
                icon: const Badge(
                  backgroundColor: AppColors.error,
                  smallSize: 8,
                  child: Icon(Icons.notifications_none, color: Colors.white, size: 22),
                ),
                onPressed: () {},
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            'Kelola izin, cuti, dinas, lembur, dan reimburse',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white60, fontSize: 10),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, String subtitle, {VoidCallback? onTapAction, String? actionLabel}) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
              Text(subtitle, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant, fontSize: 10)),
            ],
          ),
        ),
        if (onTapAction != null && actionLabel != null)
          GestureDetector(
            onTap: onTapAction,
            child: Text(actionLabel, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ),
      ],
    );
  }

  Widget _buildQuotaSummary(BuildContext context) {
    return Column(
      children: [
        _buildSectionHeader(context, 'Ringkasan Kuota', 'Tahun 2024'),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          child: Row(
            children: [
              _buildQuotaCard(context, 'Cuti Tahunan', '12 Hari', '8', 'Hari tersisa', Icons.calendar_today, AppColors.primary, AppColors.surfaceContainerHigh, 0.66),
              const SizedBox(width: 12),
              _buildQuotaCard(context, 'Cuti Khusus', 'Aktif', '3', 'Hari tersisa', Icons.event_available, AppColors.secondary, AppColors.secondaryContainer.withOpacity(0.5), 0.60, isBadgeSecondary: true),
              const SizedBox(width: 12),
              _buildQuotaCard(context, 'Saldo Reimburse', 'Plafon 2024', 'Rp 2.5jt', 'Tersedia', Icons.payments, AppColors.tertiary, AppColors.tertiaryContainer.withOpacity(0.5), 0.50, isBadgeTertiary: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuotaCard(BuildContext context, String title, String badgeText, String statValue, String statLabel, IconData icon, Color color, Color bgColor, double progress, {bool isBadgeSecondary = false, bool isBadgeTertiary = false}) {
    Color badgeBgColor = isBadgeSecondary ? AppColors.secondaryContainer.withOpacity(0.5) : (isBadgeTertiary ? AppColors.surfaceContainer : AppColors.surfaceContainerHigh);
    Color badgeTextColor = isBadgeSecondary ? AppColors.secondary : (isBadgeTertiary ? AppColors.onSurfaceVariant : AppColors.primary);

    return Container(
      width: 240,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(10)),
                      child: Icon(icon, color: color, size: 18),
                    ),
                    const SizedBox(width: 10),
                    Flexible(child: Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: badgeBgColor, borderRadius: BorderRadius.circular(12)),
                child: Text(badgeText, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: badgeTextColor, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(statValue, style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: color, fontWeight: FontWeight.bold)),
              const SizedBox(width: 6),
              Text(statLabel, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant)),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.surfaceContainerHigh,
            color: color,
            minHeight: 6,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickCategories(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context, 'Aksi Cepat', 'Pilih jenis pengajuan'),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.85,
          children: [
            _buildCategoryButton(context, 'Cuti Tahunan', Icons.beach_access, AppColors.primaryContainer.withOpacity(0.5), AppColors.primary, onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const CutiTahunanScreen()));
            }),
            _buildCategoryButton(context, 'Sakit & Izin', Icons.medication, AppColors.errorContainer.withOpacity(0.5), AppColors.error, onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const IzinSakitScreen()));
            }),
            _buildCategoryButton(context, 'Dinas Luar', Icons.flight_takeoff, AppColors.tertiaryContainer.withOpacity(0.5), AppColors.tertiary, onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const DinasLuarScreen()));
            }),
            _buildCategoryButton(context, 'Kerja Lembur', Icons.more_time, AppColors.surfaceContainer, AppColors.onSurfaceVariant, onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const KerjaLemburScreen()));
            }),
            _buildCategoryButton(context, 'Reimburse', Icons.receipt_long, AppColors.secondaryContainer.withOpacity(0.5), AppColors.secondary, onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ReimburseScreen()));
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryButton(BuildContext context, String label, IconData icon, Color bgColor, Color iconColor, {VoidCallback? onTap}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withOpacity(0.5)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap ?? () {},
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                const SizedBox(height: 8),
                Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center, maxLines: 2),
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
        children: [
          _buildFilterChip(context, 'Semua (5)', true),
          const SizedBox(width: 8),
          _buildFilterChip(context, 'Menunggu (2)', false),
          const SizedBox(width: 8),
          _buildFilterChip(context, 'Disetujui (12)', false),
          const SizedBox(width: 8),
          _buildFilterChip(context, 'Ditolak (1)', false),
        ],
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? AppColors.surface : AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isActive ? AppColors.primary : AppColors.outlineVariant.withOpacity(0.5)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: isActive ? AppColors.primary : AppColors.onSurfaceVariant,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            ),
      ),
    );
  }

  Widget _buildRequestList(BuildContext context) {
    return Column(
      children: [
        _buildRequestItem1(context),
        const SizedBox(height: 16),
        _buildRequestItem2(context),
        const SizedBox(height: 16),
        _buildRequestItem3(context),
        const SizedBox(height: 16),
        _buildRequestItem4(context),
      ],
    );
  }

  Widget _buildRequestItem1(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(color: AppColors.primaryContainer.withOpacity(0.5), borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.beach_access, color: AppColors.primary, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Cuti Tahunan', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                          Text('Diajukan: 23 Okt 2024', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant), overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: AppColors.surfaceContainerHigh, borderRadius: BorderRadius.circular(16)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
                    const SizedBox(width: 6),
                    Text('Menunggu Review', style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.surfaceContainerLowest, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.outlineVariant.withOpacity(0.5))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Durasi Cuti:', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant)),
                    Flexible(child: Text('28 Okt - 30 Okt 2024 (3 Hari)', style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Alasan:', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant)),
                const SizedBox(height: 2),
                Text('"Keperluan Urusan Keluarga di Yogyakarta"', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text('ALUR PERSETUJUAN', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant, letterSpacing: 1.0, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildTimelineItem(context, 'Diajukan oleh Karyawan', '23 Okt, 10:15', 'Formulir lengkap dan terkirim', AppColors.secondary, true),
          _buildTimelineItem(context, 'Menunggu Persetujuan', 'Dalam Proses', 'Budi Santoso • Lead Product', AppColors.primary, true, isCurrent: true),
          _buildTimelineItem(context, 'Konfirmasi HR Operations', 'Menunggu', 'Siti Rahma • HR People Ops', AppColors.outlineVariant, false, isLast: true),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Batalkan Pengajuan'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(BuildContext context, String title, String time, String desc, Color color, bool isDone, {bool isCurrent = false, bool isLast = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: isDone && !isCurrent ? color : Colors.transparent,
                shape: BoxShape.circle,
                border: isCurrent ? Border.all(color: color.withOpacity(0.3), width: 4) : Border.all(color: color, width: 2),
              ),
              child: isCurrent
                  ? Center(child: Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)))
                  : (isDone ? const Icon(Icons.check, size: 10, color: Colors.white) : null),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: AppColors.outlineVariant.withOpacity(0.5),
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(child: Text(title, style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold, color: isCurrent ? AppColors.primary : (isDone ? AppColors.onSurface : AppColors.onSurfaceVariant)), overflow: TextOverflow.ellipsis)),
                  const SizedBox(width: 8),
                  Text(time, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: isCurrent ? AppColors.primary : AppColors.onSurfaceVariant)),
                ],
              ),
              const SizedBox(height: 2),
              Text(desc, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant)),
              if (!isLast) const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRequestItem2(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(color: AppColors.secondaryContainer.withOpacity(0.5), borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.directions_subway, color: AppColors.secondary, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Klaim Biaya Transport', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                          Text('Tanggal: 18 Okt 2024', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: AppColors.secondaryContainer.withOpacity(0.5), borderRadius: BorderRadius.circular(16)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.secondary, shape: BoxShape.circle)),
                    const SizedBox(width: 6),
                    Text('Disetujui', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.secondary, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.surfaceContainerLowest, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.outlineVariant.withOpacity(0.5))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nominal Klaim:', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant)),
                      Text('Rp 450.000', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.outlineVariant.withOpacity(0.5))),
                  child: Row(
                    children: [
                      const Icon(Icons.verified, size: 16, color: AppColors.secondary),
                      const SizedBox(width: 6),
                      Text('Terverifikasi', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.secondary, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.attachment, size: 16, color: AppColors.onSurfaceVariant),
                    const SizedBox(width: 6),
                    Flexible(child: Text('Tiket KA Bandara & Invoice...', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant), overflow: TextOverflow.ellipsis)),
                  ],
                ),
              ),
              Text('Lihat Bukti', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRequestItem3(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(color: AppColors.primaryContainer.withOpacity(0.5), borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.laptop_chromebook, color: AppColors.primary, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Work From Home (WFH)', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                          Text('Tanggal: 15 Okt 2024 (1 Hari)', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant), overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: AppColors.surfaceContainerHigh, borderRadius: BorderRadius.circular(16)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.done_all, size: 14, color: AppColors.onSurface),
                    const SizedBox(width: 6),
                    Text('Selesai', style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.surfaceContainerLowest, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.outlineVariant.withOpacity(0.5))),
            child: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant),
                children: [
                  TextSpan(text: 'Catatan: ', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.onSurface)),
                  const TextSpan(text: 'Fokus pengerjaan perbaikan arsitektur dan dokumentasi modul sprint Q4.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestItem4(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(color: AppColors.surfaceContainer, borderRadius: BorderRadius.circular(10)),
                      child: const Icon(Icons.schedule, color: AppColors.onSurface, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Lembur: Peluncuran Fitur', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                          Text('Tanggal: 11 Okt 2024', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant), overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: AppColors.surfaceContainerHigh, borderRadius: BorderRadius.circular(16)),
                child: Text('3 Jam', style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(color: AppColors.surfaceContainerLowest, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.outlineVariant.withOpacity(0.5))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(child: Text('Kompensasi: Upah Lembur', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant), overflow: TextOverflow.ellipsis)),
                const SizedBox(width: 8),
                Text('Disetujui Lead', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.secondary, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryContainer),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: const Icon(Icons.help_outline, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Butuh Bantuan Kebijakan?', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                Text('Lihat panduan lengkap syarat pengajuan HR', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.primary),
        ],
      ),
    );
  }
}
