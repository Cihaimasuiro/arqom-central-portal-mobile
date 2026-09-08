import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class RequestsScreen extends StatelessWidget {
  const RequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context),
            const SizedBox(height: 24),
            _buildQuotaSummary(context),
            const SizedBox(height: 24),
            _buildQuickCategories(context),
            const SizedBox(height: 24),
            _buildStatusFilters(context),
            const SizedBox(height: 16),
            _buildRequestList(context),
            const SizedBox(height: 16),
            _buildHelpCard(context),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Image.network(
            'https://lh3.googleusercontent.com/aida/AEtjO1UQ5FkFHc88tQwC2SjPZs73JEpqNHidwBKqTHwBm0x8z1Jb3pqe4PkR-nyuqVecTLhXJ8KDwLOXHepCs7JDDhGyJPyNbxMNiqGe4HbG8WfKgwuq_q1NDzL65Gd7eRGfmCsUzZARLuPiiIq2krQDXc1pjGuqXJt3bQBcMLqbkrfcFdZx8ZxetmKnrJqQ7JbRB692emYWPnXUPcgezu0PJDulMRWjB1iMdCwW9jsdRNJxRwyFlzFXJH_NAQ',
            height: 32,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.business, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CENTRAL PORTAL',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.primary,
                      letterSpacing: 1.2,
                    ),
              ),
              Text(
                'Pengajuan',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Badge(
            backgroundColor: AppColors.error,
            smallSize: 8,
            child: Icon(Icons.notifications_none, color: AppColors.onSurfaceVariant),
          ),
          onPressed: () {},
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16.0, left: 8),
          child: CircleAvatar(
            radius: 16,
            backgroundImage: const NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuCQaJC_jqiMNv49kn_uPFhMrLFxMpa3Qu3nY6nqMPw-N6uQ_jRmb97FIVoScHuTlylqtomh7l4_6GV1H0_OdpCyrYwYG2dBookxNmturNgp_b0H84d2FN1HQSenXM0FpqJ3JtkouZi7y009HZT5gX7i7rzRsyY2ohzMq5tjfKxlRScR-uyqZVzi5lVGkPJItshRl1DZBAumcAZrEykiEdf7mgKYmClyoFWpsTK2b0LHloUGG3t19UI'),
            backgroundColor: AppColors.primaryFixed,
            onBackgroundImageError: (_, __) {},
            child: const Icon(Icons.person, size: 20, color: AppColors.onPrimaryFixed),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Pusat Pengajuan', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 4),
              Text('Kelola izin, cuti, dinas, lembur, dan reimbursement Anda', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant)),
            ],
          ),
        ),
        const SizedBox(width: 12),
        FilledButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add, size: 20),
          label: const Text('Buat Baru'),
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildQuotaSummary(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: Text('RINGKASAN KUOTA & PLAFON', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.onSurfaceVariant, letterSpacing: 1.2), overflow: TextOverflow.ellipsis)),
            const SizedBox(width: 8),
            Text('Tahun 2024', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.primary)),
          ],
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          child: Row(
            children: [
              _buildQuotaCard(context, 'Cuti Tahunan', '12 Hari', '8', 'Hari tersisa', Icons.calendar_today, AppColors.primary, AppColors.surfaceContainerHigh, 0.66),
              const SizedBox(width: 12),
              _buildQuotaCard(context, 'Cuti Khusus', 'Aktif', '3', 'Hari tersisa', Icons.event_available, AppColors.secondary, AppColors.secondaryFixed, 0.60, isBadgeSecondary: true),
              const SizedBox(width: 12),
              _buildQuotaCard(context, 'Saldo Reimburse', 'Plafon 2024', 'Rp 2.5jt', 'Tersedia', Icons.payments, AppColors.tertiary, AppColors.tertiaryFixed, 0.50, isBadgeTertiary: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuotaCard(BuildContext context, String title, String badgeText, String statValue, String statLabel, IconData icon, Color color, Color bgColor, double progress, {bool isBadgeSecondary = false, bool isBadgeTertiary = false}) {
    Color badgeBgColor = isBadgeSecondary ? AppColors.secondaryFixed : (isBadgeTertiary ? AppColors.surfaceContainer : AppColors.surfaceContainerHigh);
    Color badgeTextColor = isBadgeSecondary ? AppColors.onSecondaryFixedVariant : (isBadgeTertiary ? AppColors.onSurfaceVariant : AppColors.primary);

    return Container(
      width: 240,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
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
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8)),
                      child: Icon(icon, color: color, size: 16),
                    ),
                    const SizedBox(width: 8),
                    Flexible(child: Text(title, style: Theme.of(context).textTheme.titleSmall, overflow: TextOverflow.ellipsis)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: badgeBgColor, borderRadius: BorderRadius.circular(12)),
                child: Text(badgeText, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: badgeTextColor)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(statValue, style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: color, fontWeight: FontWeight.bold)),
              const SizedBox(width: 4),
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
        Text('AKSI CEPAT JENIS PENGAJUAN', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.onSurfaceVariant, letterSpacing: 1.2)),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.0,
          children: [
            _buildCategoryButton(context, 'Cuti Tahunan', Icons.beach_access, AppColors.primaryFixed, AppColors.primary),
            _buildCategoryButton(context, 'Sakit & Izin', Icons.medication, AppColors.errorContainer, AppColors.error),
            _buildCategoryButton(context, 'Dinas Luar', Icons.flight_takeoff, AppColors.tertiaryFixed, AppColors.onTertiaryFixedVariant),
            _buildCategoryButton(context, 'Kerja Lembur', Icons.more_time, AppColors.surfaceVariant, AppColors.onSurfaceVariant),
            _buildCategoryButton(context, 'Reimburse', Icons.receipt_long, AppColors.secondaryFixed, AppColors.secondary),
            _buildCategoryButton(context, 'WFH / Remote', Icons.home_work, AppColors.surfaceContainerHighest, AppColors.primary),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryButton(BuildContext context, String label, IconData icon, Color bgColor, Color iconColor) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 1))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(height: 8),
                Text(label, style: Theme.of(context).textTheme.labelSmall, textAlign: TextAlign.center, maxLines: 2),
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
          const SizedBox(width: 8),
          _buildFilterChip(context, 'Perlu Revisi (0)', false),
        ],
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: isActive ? AppColors.onPrimary : AppColors.onSurfaceVariant,
              fontWeight: FontWeight.bold,
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
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
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
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(color: AppColors.surfaceContainerHigh, borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.beach_access, color: AppColors.primary, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Cuti Tahunan', style: Theme.of(context).textTheme.titleSmall, overflow: TextOverflow.ellipsis),
                          Text('Diajukan: 23 Okt 2024', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant), overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppColors.surfaceContainer, borderRadius: BorderRadius.circular(16)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
                    const SizedBox(width: 4),
                    Text('Menunggu Review', style: Theme.of(context).textTheme.labelSmall),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Durasi Cuti:', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant)),
                    Flexible(child: Text('28 Okt - 30 Okt 2024 (3 Hari Kerja)', style: Theme.of(context).textTheme.labelMedium, overflow: TextOverflow.ellipsis)),
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
          Text('ALUR PERSETUJUAN', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant, letterSpacing: 1.2)),
          const SizedBox(height: 12),
          _buildTimelineItem(context, 'Diajukan oleh Karyawan', '23 Okt, 10:15', 'Formulir lengkap dan terkirim', AppColors.secondary, true),
          _buildTimelineItem(context, 'Menunggu Persetujuan', 'Dalam Proses', 'Budi Santoso • Lead Product', AppColors.primary, true, isCurrent: true),
          _buildTimelineItem(context, 'Konfirmasi HR Operations', 'Menunggu', 'Siti Rahma • HR People Ops', AppColors.outlineVariant, false, isLast: true),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
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
                color: AppColors.surfaceContainerHigh,
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
                  Flexible(child: Text(title, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: isCurrent ? AppColors.primary : (isDone ? AppColors.onSurface : AppColors.onSurfaceVariant)), overflow: TextOverflow.ellipsis)),
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
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
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
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(color: AppColors.secondaryFixed, borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.directions_subway, color: AppColors.secondary, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Klaim Biaya Transportasi Dinas', style: Theme.of(context).textTheme.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                          Text('Tanggal: 18 Okt 2024', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppColors.secondaryFixed, borderRadius: BorderRadius.circular(16)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.secondary, shape: BoxShape.circle)),
                    const SizedBox(width: 4),
                    Text('Disetujui', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSecondaryFixedVariant)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(8)),
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
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.surfaceContainerLowest, borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      const Icon(Icons.verified, size: 16, color: AppColors.secondary),
                      const SizedBox(width: 4),
                      Text('Terverifikasi Finansial', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.secondary)),
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
                    const Icon(Icons.attachment, size: 18, color: AppColors.onSurfaceVariant),
                    const SizedBox(width: 4),
                    Flexible(child: Text('Tiket KA Bandara & Invoice...', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant), overflow: TextOverflow.ellipsis)),
                  ],
                ),
              ),
              Text('Lihat Bukti', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.primary)),
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
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
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
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(color: AppColors.surfaceContainerHighest, borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.laptop_chromebook, color: AppColors.primary, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Work From Home (WFH)', style: Theme.of(context).textTheme.titleSmall, overflow: TextOverflow.ellipsis),
                          Text('Tanggal: 15 Okt 2024 (1 Hari)', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant), overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppColors.secondaryFixed, borderRadius: BorderRadius.circular(16)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.done_all, size: 14, color: AppColors.onSecondaryFixedVariant),
                    const SizedBox(width: 4),
                    Text('Selesai', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSecondaryFixedVariant)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(8)),
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
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
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
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.schedule, color: AppColors.primary, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Lembur: Peluncuran Fitur', style: Theme.of(context).textTheme.titleSmall, overflow: TextOverflow.ellipsis),
                          Text('Tanggal: 11 Okt 2024', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant), overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppColors.surfaceContainerHigh, borderRadius: BorderRadius.circular(16)),
                child: Text('3 Jam Kerja', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(child: Text('Kompensasi: Upah Lembur Standar', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant), overflow: TextOverflow.ellipsis)),
                const SizedBox(width: 8),
                Text('Disetujui Lead Tech', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.secondary)),
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
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(color: AppColors.surfaceContainerLowest, shape: BoxShape.circle),
            child: const Icon(Icons.help_outline, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Butuh Bantuan Kebijakan Cuti?', style: Theme.of(context).textTheme.titleSmall),
                Text('Lihat panduan lengkap syarat pengajuan HR & operasional', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.primary),
        ],
      ),
    );
  }
}
