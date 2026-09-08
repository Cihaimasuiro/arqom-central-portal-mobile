import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/live_clock_widget.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

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
            _buildInteractiveAttendanceCard(context),
            const SizedBox(height: 16),
            _buildCheckOutButton(context),
            const SizedBox(height: 16),
            _buildStatisticsSummary(context),
            const SizedBox(height: 16),
            _buildAttendanceCalendar(context),
            const SizedBox(height: 16),
            _buildAttendanceHistory(context),
            const SizedBox(height: 16),
            _buildQuickActions(context),
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
                'Kehadiran',
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

  Widget _buildInteractiveAttendanceCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryContainer.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.secondary, shape: BoxShape.circle)),
                        const SizedBox(width: 6),
                        Flexible(child: Text('Sudah Presensi Masuk', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.secondary), overflow: TextOverflow.ellipsis)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.calendar_today, size: 16, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text('Kamis, 24 Okt 2024', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.onSurfaceVariant)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            LiveClockWidget(
              timeStyle: Theme.of(context).textTheme.displayLarge,
              amPmStyle: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.verified, size: 14, color: AppColors.secondary),
                const SizedBox(width: 4),
                Text('Shift Normal: 08:30 - 17:30 WIB', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant)),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildAttendanceMetric(context, 'Jam Masuk', '08:28', 'Tepat Waktu', AppColors.primary, AppColors.secondary),
                  Container(width: 1, height: 40, color: AppColors.outlineVariant.withOpacity(0.3)),
                  _buildAttendanceMetric(context, 'Jam Pulang', '--:--', 'Belum Checkout', AppColors.onSurfaceVariant, AppColors.outline),
                  Container(width: 1, height: 40, color: AppColors.outlineVariant.withOpacity(0.3)),
                  _buildAttendanceMetric(context, 'Durasi Kerja', '6j 00m', 'Berjalan', AppColors.onSurface, AppColors.secondary, isDuration: true),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh.withOpacity(0.4),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on, color: AppColors.primary, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Gedung Menara Mandiri Lt. 18', style: Theme.of(context).textTheme.titleSmall),
                            Text('Jl. Jend. Sudirman, Jakarta Selatan', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: AppColors.secondaryContainer, borderRadius: BorderRadius.circular(16)),
                        child: Row(
                          children: [
                            const Icon(Icons.radar, size: 12, color: AppColors.onSecondaryContainer),
                            const SizedBox(width: 4),
                            Text('Radius Valid', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSecondaryContainer, fontSize: 10)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 96,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(8),
                      image: const DecorationImage(
                        image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuAyGGxxsQamWwMr6dJIKt85_DHthB9MwHTt2Tc3xBWk7v5EGvTxxLy58swZ_TBIw3tSm0qt1fyu-upi40unm4mZyFA2Hl3FBXWOXSuCc1_4iiUVtjmsV-v4XqjTRcBdyVTT6Rnwe08RIhO_oHA-qIfos7pU1-76kKPrxbJSmH9Cq-C6DWK1JQ96ml0eun0I-K6jrHlHPIu6KhNXm7xIBcCvhIHCXITbrGc0XtO0fRgAhK1GZG16LIc'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Container(color: AppColors.primary.withOpacity(0.1)),
                        Center(
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                            child: const Icon(Icons.apartment, size: 14, color: AppColors.onPrimary),
                          ),
                        ),
                        Positioned(
                          bottom: 6,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(color: AppColors.surfaceContainerLowest.withOpacity(0.9), borderRadius: BorderRadius.circular(6)),
                            child: Row(
                              children: [
                                const Icon(Icons.my_location, size: 12, color: AppColors.secondary),
                                const SizedBox(width: 4),
                                Text('Akurasi GPS: 8 meter', style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 10)),
                              ],
                            ),
                          ),
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

  Widget _buildAttendanceMetric(BuildContext context, String label, String value, String status, Color valueColor, Color statusColor, {bool isDuration = false}) {
    return Column(
      children: [
        Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant)),
        const SizedBox(height: 2),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(value, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: valueColor)),
            if (!isDuration) ...[
              const SizedBox(width: 2),
              Text('WIB', style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 10, fontWeight: FontWeight.normal, color: valueColor)),
            ],
          ],
        ),
        const SizedBox(height: 4),
        Text(status, style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 10, color: statusColor)),
      ],
    );
  }

  Widget _buildCheckOutButton(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 64,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.error, Colors.redAccent, Colors.orange],
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(color: AppColors.error.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4)),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                            child: const Icon(Icons.fingerprint, color: AppColors.onPrimary, size: 26),
                          ),
                          const SizedBox(width: 12),
                          Flexible(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Presensi Pulang Kerja', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.onPrimary), overflow: TextOverflow.ellipsis),
                                Text('Tekan & tahan untuk check-out biometrik', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white70), overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                      child: const Icon(Icons.east, color: AppColors.onPrimary, size: 20),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Tahan 1.5 detik untuk verifikasi identitas wajah & sidik jari',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildStatisticsSummary(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Ringkasan Presensi', style: Theme.of(context).textTheme.titleMedium),
            Text('Oktober 2024', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.primary)),
          ],
        ),
        const SizedBox(height: 8),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 1.2,
          children: [
            _buildStatCard(context, 'Tepat Waktu', '17', Icons.check_circle, AppColors.secondary, AppColors.secondaryContainer.withOpacity(0.4)),
            _buildStatCard(context, 'Terlambat', '1', Icons.schedule, Colors.orange[700]!, Colors.orange[100]!),
            _buildStatCard(context, 'Cuti', '2', Icons.beach_access, AppColors.primary, AppColors.surfaceContainerHigh),
            _buildStatCard(context, 'Sakit', '0', Icons.medication, AppColors.outline, AppColors.surfaceContainer),
            _buildStatCard(context, 'Dinas', '1', Icons.flight_takeoff, AppColors.tertiary, AppColors.tertiaryFixed),
            _buildStatCard(context, 'Alpha', '0', Icons.cancel, AppColors.outline, AppColors.surfaceContainer),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, String label, String value, IconData icon, Color iconColor, Color iconBg) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 10, color: AppColors.onSurfaceVariant))),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
                  child: Icon(icon, size: 14, color: iconColor),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(value, style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: iconColor, fontWeight: FontWeight.bold)),
                const SizedBox(width: 4),
                Text('Hari', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceCalendar(BuildContext context) {
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
                      const Icon(Icons.date_range, color: AppColors.primary, size: 20),
                      const SizedBox(width: 8),
                      Flexible(child: Text('Kalender Presensi', style: Theme.of(context).textTheme.titleSmall, overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildLegendItem(context, AppColors.secondary, 'Hadir'),
                    const SizedBox(width: 8),
                    _buildLegendItem(context, Colors.orange, 'Late'),
                    const SizedBox(width: 8),
                    _buildLegendItem(context, AppColors.primary, 'Cuti'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCalendarDay(context, 'SEN', '21', Colors.orange, AppColors.surfaceContainerLow.withOpacity(0.7)),
                _buildCalendarDay(context, 'SEL', '22', AppColors.secondary, AppColors.surfaceContainerLow.withOpacity(0.7)),
                _buildCalendarDay(context, 'RAB', '23', AppColors.secondary, AppColors.surfaceContainerLow.withOpacity(0.7)),
                _buildCalendarDay(context, 'KAM', '24', AppColors.secondaryContainer, AppColors.primary, isToday: true),
                _buildCalendarDay(context, 'JUM', '25', Colors.transparent, AppColors.surfaceContainerLow.withOpacity(0.7), opacity: 0.6),
                _buildCalendarDay(context, 'SAB', '26', Colors.transparent, AppColors.surfaceContainerLow.withOpacity(0.3), isWeekend: true, opacity: 0.4),
                _buildCalendarDay(context, 'MIN', '27', Colors.transparent, AppColors.surfaceContainerLow.withOpacity(0.3), isWeekend: true, opacity: 0.4),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(BuildContext context, Color color, String label) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 10, color: AppColors.onSurfaceVariant)),
      ],
    );
  }

  Widget _buildCalendarDay(BuildContext context, String day, String date, Color dotColor, Color bgColor, {bool isToday = false, bool isWeekend = false, double opacity = 1.0}) {
    return Opacity(
      opacity: opacity,
      child: Container(
        width: 40,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(day, style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 10, color: isToday ? AppColors.primaryFixed : (isWeekend ? AppColors.error : AppColors.onSurfaceVariant))),
            const SizedBox(height: 2),
            Text(date, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: isToday ? AppColors.onPrimary : AppColors.onSurface)),
            const SizedBox(height: 6),
            Container(width: 6, height: 6, decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle)),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceHistory(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: Text('Riwayat Presensi', style: Theme.of(context).textTheme.titleMedium, overflow: TextOverflow.ellipsis)),
            const SizedBox(width: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Lihat Semua', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.primary)),
                const Icon(Icons.chevron_right, size: 16, color: AppColors.primary),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        _buildHistoryItem(context, 'Rabu, 23 Okt 2024', 'Lengkap', '08:25 - 17:35 WIB • 9j 10m • Kantor Pusat', AppColors.secondary, Icons.done_all),
        const SizedBox(height: 8),
        _buildHistoryItem(context, 'Selasa, 22 Okt 2024', 'Lengkap', '08:20 - 17:40 WIB • 9j 20m • Kantor Pusat', AppColors.secondary, Icons.done_all),
        const SizedBox(height: 8),
        _buildHistoryItem(context, 'Senin, 21 Okt 2024', 'Telat 12 Menit', '08:42 - 17:45 WIB • Alasan Macet Lalu Lintas', Colors.orange[700]!, Icons.warning, isLate: true),
      ],
    );
  }

  Widget _buildHistoryItem(BuildContext context, String date, String status, String desc, Color statusColor, IconData icon, {bool isLate = false}) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: isLate ? Colors.orange[100] : AppColors.secondaryContainer.withOpacity(0.4), shape: BoxShape.circle),
              child: Icon(icon, color: statusColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(child: Text(date, style: Theme.of(context).textTheme.titleSmall, overflow: TextOverflow.ellipsis)),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: isLate ? Colors.orange[100] : AppColors.secondaryContainer.withOpacity(0.4), borderRadius: BorderRadius.circular(16)),
                        child: Text(status, style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 10, color: isLate ? Colors.orange[800] : AppColors.secondary)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(desc, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.outline, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('AKSI & BANTUAN CEPAT', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.onSurfaceVariant, letterSpacing: 1.2)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildActionItem(context, Icons.edit_calendar, 'Koreksi Presensi', AppColors.primaryFixed, AppColors.primary)),
              const SizedBox(width: 8),
              Expanded(child: _buildActionItem(context, Icons.event_busy, 'Pengajuan Izin', AppColors.secondaryContainer, AppColors.secondary)),
              const SizedBox(width: 8),
              Expanded(child: _buildActionItem(context, Icons.analytics, 'Rekap Lengkap', AppColors.surfaceContainerHigh, AppColors.primary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem(BuildContext context, IconData icon, String label, Color bgColor, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 8),
          Text(label, style: Theme.of(context).textTheme.labelSmall, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
