import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/live_clock_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, MediaQuery.of(context).padding.top + kToolbarHeight + 20, 16, 100), // Bottom padding for nav bar
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildProfileGreeting(context),
            const SizedBox(height: 16),
            _buildShiftInfo(context),
            const SizedBox(height: 16),
            _buildAttendanceStatus(context),
            const SizedBox(height: 16),
            _buildPendingApproval(context),
            const SizedBox(height: 16),
            _buildQuickAccess(context),
            const SizedBox(height: 16),
            _buildPerformanceSummary(context),
            const SizedBox(height: 16),
            _buildMeetingAgenda(context),
            const SizedBox(height: 16),
            _buildInternalAnnouncement(context),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: AppBar(
            backgroundColor: AppColors.surface.withOpacity(0.85),
            elevation: 0,
            scrolledUnderElevation: 0,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black.withOpacity(0.04),
                    width: 1,
                  ),
                ),
              ),
            ),
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
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      'Beranda',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
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
          ),
        ),
      ),
    );
  }

  Widget _buildProfileGreeting(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuDk69nzXOWIZ_yXXDFx8386G1Z6Ph5S10LxEJnpkzu10gB78Hs89OZdfGtY_i8LHgP_W7N1KyIeE2WaQcAs_1m9k7JMvQaRlS5pNdWPQBfjqghEfpc16H2wgp1W5NeCtsH-uLJLQ_oUXz_Kck5VyGv63AI_XtMgT57Bbj-HfNAXZWPGZMKCAMEpzVqRnUqpuBIAgEej1IFBVzFi-YsNgV--EClZwS0FTKht7MiL9eTqrr_hwo2jUOM'),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.surface, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Selamat Pagi, Rizky!', style: Theme.of(context).textTheme.headlineSmall),
                Text(
                  'Senior Product Designer • PT Nusantara',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.secondaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: AppColors.secondary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'WFO Jakarta',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSecondaryContainer),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '24 Okt 2024',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShiftInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.schedule, color: AppColors.primary, size: 18),
                const SizedBox(width: 8),
                Flexible(child: Text('Shift Pagi Regular', style: Theme.of(context).textTheme.labelMedium, overflow: TextOverflow.ellipsis)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '08:30 - 17:30 WIB',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceStatus(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'STATUS PRESENSI HARI INI',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              'Belum Presensi Masuk',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.error),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryContainer.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.near_me, size: 16, color: AppColors.secondary),
                      const SizedBox(width: 6),
                      Text(
                        'Radius Kantor (12m)',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSecondaryContainer),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Live Clock Widget
            LiveClockWidget(
              timeStyle: Theme.of(context).textTheme.displayLarge,
              amPmStyle: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.onSurfaceVariant),
            ),
            Text(
              'Batas toleransi masuk: 08:45 WIB',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.surfaceTint],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.fingerprint, color: AppColors.onPrimary, size: 20),
                              const SizedBox(width: 8),
                              Text('Masuk Kerja', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.onPrimary)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.surfaceContainerHigh,
                      foregroundColor: AppColors.outline,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.logout),
                    label: const Text('Pulang'),
                    onPressed: null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildPastAttendanceInfo(context, Icons.login, AppColors.secondary, 'Kemarin Masuk', '08:24 WIB'),
                  Container(width: 1, height: 24, color: AppColors.outlineVariant.withOpacity(0.5)),
                  _buildPastAttendanceInfo(context, Icons.logout, AppColors.onSurfaceVariant, 'Kemarin Pulang', '17:32 WIB'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPastAttendanceInfo(BuildContext context, IconData icon, Color iconColor, String label, String time) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: iconColor),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant), overflow: TextOverflow.ellipsis),
                Text(time, style: Theme.of(context).textTheme.titleSmall, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingApproval(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.errorContainer.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.errorContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.pending_actions, color: AppColors.onErrorContainer),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        'MENUNGGU PERSETUJUAN',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onErrorContainer),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '1 Tiket',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onErrorContainer),
                    ),
                  ],
                ),
                Text(
                  'Cuti Tahunan (28 Okt 2024) • Review Manager',
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.onSurfaceVariant),
        ],
      ),
    );
  }

  Widget _buildQuickAccess(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Akses Cepat Layanan', style: Theme.of(context).textTheme.titleMedium),
                Text(
                  '8 Fitur Utama',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 16,
                crossAxisSpacing: 8,
                mainAxisExtent: 92,
              ),
              children: [
                _buildQuickActionItem(context, Icons.history_toggle_off, 'Kehadiran', AppColors.primaryFixed, AppColors.primary),
                _buildQuickActionItem(context, Icons.menu_book, 'Logbook', AppColors.secondaryFixed, AppColors.secondary),
                _buildQuickActionItem(context, Icons.flag, 'Rencana', AppColors.surfaceContainerHigh, AppColors.primaryContainer),
                _buildQuickActionItem(context, Icons.event_available, 'Pengajuan', AppColors.errorContainer.withOpacity(0.6), AppColors.error),
                _buildQuickActionItem(context, Icons.flight_takeoff, 'Dinas Luar', AppColors.tertiaryFixed, AppColors.tertiary),
                _buildQuickActionItem(context, Icons.folder_special, 'SOP & Arsip', AppColors.surfaceContainerHighest, AppColors.onSurfaceVariant),
                _buildQuickActionItem(context, Icons.groups, 'Daftar Tim', AppColors.primaryFixedDim.withOpacity(0.4), AppColors.primary),
                _buildQuickActionItem(context, Icons.apps, 'Lainnya', AppColors.surfaceContainer, AppColors.onSurface),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionItem(BuildContext context, IconData icon, String label, Color bgColor, Color iconColor) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(height: 1.2),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceSummary(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.insights, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Flexible(child: Text('Ringkasan Kinerja', style: Theme.of(context).textTheme.titleMedium, overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Q4 2024',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSecondaryContainer),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Evaluasi KPI', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant)),
                        const SizedBox(height: 4),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text('87.5', style: Theme.of(context).textTheme.titleLarge),
                            const SizedBox(width: 4),
                            Text('/ 100', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.secondary,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Sangat Baik',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSecondary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Pencapaian OKR', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant), overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 4),
                              Text('76%', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.primary)),
                              Text('Target: 80%', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 4),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 40,
                              height: 40,
                              child: CircularProgressIndicator(
                                value: 0.76,
                                strokeWidth: 4,
                                backgroundColor: AppColors.surfaceContainerHighest,
                                color: AppColors.primary,
                              ),
                            ),
                            Text('Q4', style: Theme.of(context).textTheme.labelSmall),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Tugas Bulan Ini', style: Theme.of(context).textTheme.labelMedium),
                      Text('18 / 24 Selesai (75%)', style: Theme.of(context).textTheme.labelMedium),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: 0.75,
                    backgroundColor: AppColors.surfaceContainerHighest,
                    color: AppColors.primary,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {},
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Lihat Analisis Lengkap'),
                  SizedBox(width: 4),
                  Icon(Icons.arrow_forward, size: 18),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeetingAgenda(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.calendar_month, color: AppColors.primary, size: 20),
                      const SizedBox(width: 8),
                      Flexible(child: Text('Agenda Rapat Terdekat', style: Theme.of(context).textTheme.titleMedium, overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text('Hari Ini', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant)),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text('09:30', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.primary)),
                        Text('10:30', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.secondary, shape: BoxShape.circle)),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Sprint Planning Q4 & Review OKR',
                                style: Theme.of(context).textTheme.titleSmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Ruang Rinjani 302 • 6 Peserta Terkonfirmasi',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            SizedBox(
                              width: 60,
                              height: 24,
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 0,
                                    child: CircleAvatar(
                                      radius: 12,
                                      backgroundColor: AppColors.surface,
                                      child: const CircleAvatar(radius: 11, backgroundImage: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuB0Q-IMVSNKuWFtNzNPrDe5MMRdrwZL6lzcGQW5eh4A0YezhiNuo42Wy5rB_HhATSToWvxj_7JA35HiDHB0Mr0XJxp0Ry1KnqCnYDc2DsAJEbpVAU7OHPEE6FhgFX63QNIygT2iImmsUPEBOYaAg0EiBfcsF8yNdEyMbLNFzf1_qBrarDiPkewPslpzigw3p_ZRn3-pic1Tg924PKEcEntj4uAzhOZ1h42I9OEwCUTBF-dQMt-8LAA')),
                                    ),
                                  ),
                                  Positioned(
                                    left: 18,
                                    child: CircleAvatar(
                                      radius: 12,
                                      backgroundColor: AppColors.surface,
                                      child: const CircleAvatar(radius: 11, backgroundImage: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuCpHnATzPtBicdFs9vkb6P78-Mxdi2hitTg88auKwcn41zq3yRfJsktyxaX4QZCB_xJEKnQXDm8EmlcqUoWzmMGi372DLv8pwt70ecGa1KX6TjL7CsKRvq3zls0piUfPYc6DNf3Yi_tY5JXPRCNsk_XKMv5P4wbeRmw9QBMnxPpcO5bAHptGZfkIg7AR9VY6mQ0yYTV9QokBzZCENzEIFkFg-HMcz9YmGiZVC6oz7gQ1LZHwOZoTfg')),
                                    ),
                                  ),
                                  Positioned(
                                    left: 36,
                                    child: CircleAvatar(
                                      radius: 12,
                                      backgroundColor: AppColors.surface,
                                      child: CircleAvatar(
                                        radius: 11,
                                        backgroundColor: AppColors.surfaceContainerHighest,
                                        child: Text('+4', style: Theme.of(context).textTheme.labelSmall),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'Ruang Rinjani 302',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.primary),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInternalAnnouncement(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.campaign, color: AppColors.secondary, size: 20),
                      const SizedBox(width: 8),
                      Flexible(child: Text('Pengumuman Internal', style: Theme.of(context).textTheme.titleMedium, overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text('Semua', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.primary)),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primaryFixed,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text('Penting', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onPrimaryFixed)),
                      ),
                      Text('Management Office', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Townhall Triwulan IV & Sosialisasi Kebijakan Kerja Terpadu 2025', style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 4),
                  Text(
                    'Seluruh staf PT Nusantara Teknologi Mandiri diundang menghadiri sesi hybrid interaktif mengenai pencapaian bisnis dan peresmian skema tunjangan baru.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(child: Text('Jumat, 25 Okt • Auditorium Lt. 4', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant), overflow: TextOverflow.ellipsis)),
                      const SizedBox(width: 8),
                      Text('Lihat Detail', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.primary)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
