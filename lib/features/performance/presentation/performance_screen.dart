import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class PerformanceScreen extends StatelessWidget {
  const PerformanceScreen({super.key});

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
            _buildProfileSubHeader(context),
            const SizedBox(height: 16),
            _buildTabNavigation(context),
            const SizedBox(height: 16),
            _buildHeroScorecard(context),
            const SizedBox(height: 16),
            _buildAlignmentHierarchy(context),
            const SizedBox(height: 16),
            _buildQuickLogbook(context),
            const SizedBox(height: 16),
            _buildOkrSection(context),
            const SizedBox(height: 16),
            _buildKpiAnalysisSection(context),
            const SizedBox(height: 16),
            _buildWorkPlanSection(context),
            const SizedBox(height: 16),
            _buildFooterActions(context),
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
                'Kinerja',
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

  Widget _buildProfileSubHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Flexible(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(color: AppColors.primaryFixed, shape: BoxShape.circle),
                      child: const Icon(Icons.verified_user, color: AppColors.primary, size: 24),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(width: 12, height: 12, decoration: const BoxDecoration(color: AppColors.secondary, shape: BoxShape.circle)),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(child: Text('Rizky Pratama', style: Theme.of(context).textTheme.titleSmall, overflow: TextOverflow.ellipsis)),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(color: AppColors.surfaceContainerHigh, borderRadius: BorderRadius.circular(12)),
                            child: Text('Lead UX', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.primary)),
                          ),
                        ],
                      ),
                      Text('Divisi Desain Produk • Q4 2024', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.event, color: AppColors.secondary, size: 18),
                const SizedBox(width: 4),
                Text('Triwulan IV', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.secondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabNavigation(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(12)),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildTab(context, 'Ringkasan & OKR', true),
            _buildTab(context, 'KPI', false),
            _buildTab(context, 'Rencana Kerja', false),
            _buildTab(context, 'Logbook & Laporan', false),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(BuildContext context, String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? AppColors.surfaceContainerLowest : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        boxShadow: isActive ? [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 1))] : null,
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: isActive ? AppColors.primary : AppColors.onSurfaceVariant,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
            ),
      ),
    );
  }

  Widget _buildHeroScorecard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppColors.primary, AppColors.primaryContainer]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.military_tech, color: AppColors.primaryFixed, size: 20),
                    const SizedBox(width: 4),
                    Flexible(child: Text('INDEKS KINERJA PEGAWAI', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.primaryFixed, letterSpacing: 1.2), overflow: TextOverflow.ellipsis)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(color: AppColors.secondary, borderRadius: BorderRadius.circular(16)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.secondaryFixed, shape: BoxShape.circle)),
                    const SizedBox(width: 4),
                    Text('On Track', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSecondary)),
                  ],
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
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Skor Total KPI', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.primaryFixed)),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text('87.5', style: Theme.of(context).textTheme.displayLarge?.copyWith(color: AppColors.onPrimary)),
                          Text('/100', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.primaryFixed)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(color: AppColors.secondaryContainer, borderRadius: BorderRadius.circular(12)),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.trending_up, size: 14, color: AppColors.onSecondaryContainer),
                                const SizedBox(width: 4),
                                Text('+3.2%', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSecondaryContainer)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text('vs bln lalu', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.primaryFixedDim)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('Predikat: Sangat Baik', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onPrimary, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 80,
                              height: 80,
                              child: CircularProgressIndicator(value: 0.76, strokeWidth: 6, backgroundColor: Colors.white.withOpacity(0.2), color: AppColors.secondaryFixed),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('76%', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.onPrimary, fontWeight: FontWeight.bold)),
                                Text('Tercapai', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.primaryFixed, fontSize: 10)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('3 Objective • 8 Key Result', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.primaryFixed)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAlignmentHierarchy(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 4, offset: const Offset(0, 1))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.account_tree, color: AppColors.primary, size: 18),
                    const SizedBox(width: 4),
                    Flexible(child: Text('Pohon Keterikatan Sasaran Strategis', style: Theme.of(context).textTheme.labelMedium, overflow: TextOverflow.ellipsis)),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text('100% Selaras', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildHierarchyNode(context, 'OKR Korporat', Icons.corporate_fare, true),
                const Icon(Icons.arrow_forward, size: 14, color: AppColors.outlineVariant),
                _buildHierarchyNode(context, 'KPI Tim UX', null, false),
                const Icon(Icons.arrow_forward, size: 14, color: AppColors.outlineVariant),
                _buildHierarchyNode(context, 'Program Q4', null, false),
                const Icon(Icons.arrow_forward, size: 14, color: AppColors.outlineVariant),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.primaryFixed, borderRadius: BorderRadius.circular(16)),
                  child: Text('Logbook Harian', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onPrimaryFixed)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHierarchyNode(BuildContext context, String label, IconData? icon, bool isPrimary) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 2, offset: const Offset(0, 1))],
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: isPrimary ? AppColors.primary : AppColors.onSurface),
            const SizedBox(width: 4),
          ],
          Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: isPrimary ? AppColors.primary : AppColors.onSurface)),
        ],
      ),
    );
  }

  Widget _buildQuickLogbook(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: AppColors.secondaryContainer, borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.edit_note, color: AppColors.onSecondaryContainer),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Aktivitas Hari Ini', style: Theme.of(context).textTheme.titleSmall, overflow: TextOverflow.ellipsis),
                  Text('Terhubung langsung ke Objective 1', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant), overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            const SizedBox(width: 8),
            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Logbook'),
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOkrSection(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.track_changes, color: AppColors.primary, size: 22),
                  const SizedBox(width: 8),
                  Flexible(child: Text('Sasaran Kinerja Utama (OKR)', style: Theme.of(context).textTheme.titleMedium, overflow: TextOverflow.ellipsis)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text('Lihat Semua', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.primary)),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: AppColors.primaryFixed, borderRadius: BorderRadius.circular(16)),
                        child: Text('Objective 1', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onPrimaryFixed), overflow: TextOverflow.ellipsis),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.secondary, shape: BoxShape.circle)),
                        const SizedBox(width: 4),
                        Text('On Track', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.secondary)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Meningkatkan Skor Adopsi Fitur Desain Sistem Perusahaan', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(child: Text('Kemajuan Keseluruhan', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant), overflow: TextOverflow.ellipsis)),
                    const SizedBox(width: 8),
                    Text('82%', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.primary)),
                  ],
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(value: 0.82, backgroundColor: AppColors.surfaceContainerHigh, color: AppColors.primary, minHeight: 8, borderRadius: BorderRadius.circular(4)),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: AppColors.surfaceContainerLow.withOpacity(0.5), borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('HASIL KUNCI (KEY RESULTS)', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant, letterSpacing: 1.2)),
                      const SizedBox(height: 8),
                      _buildKeyResult(context, 'Publikasi 15 komponen baru standar WCAG AA', 1.0, '100%', AppColors.secondary, Icons.check_circle, AppColors.secondaryContainer, AppColors.onSecondaryContainer),
                      const SizedBox(height: 8),
                      _buildKeyResult(context, 'Kurangi turnaround iterasi desain dari 5 hari ke 2 hari', 0.75, '75% (2.5 hr)', AppColors.primary, Icons.timelapse, AppColors.primaryFixed, AppColors.onPrimaryFixed),
                      const SizedBox(height: 8),
                      _buildKeyResult(context, 'Skor kepuasan tim tech terhadap UI kit ≥ 90', 0.70, '70% (Skor 84)', AppColors.primary, Icons.sentiment_satisfied, AppColors.surfaceContainerHigh, AppColors.onSurfaceVariant),
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
                          const Icon(Icons.calendar_today, size: 16, color: AppColors.onSurfaceVariant),
                          const SizedBox(width: 4),
                          Flexible(child: Text('Tenggat: 15 Des 2024', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant), overflow: TextOverflow.ellipsis)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Icon(Icons.person, size: 16, color: AppColors.onSurfaceVariant),
                          const SizedBox(width: 4),
                          Flexible(child: Text('Pemilik: Rizky Pratama', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant), overflow: TextOverflow.ellipsis)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: AppColors.surfaceContainerHigh, borderRadius: BorderRadius.circular(16)),
                        child: Text('Objective 2', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant), overflow: TextOverflow.ellipsis),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
                        const SizedBox(width: 4),
                        Text('Dalam Progress', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.primary)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Meningkatkan Efisiensi Dokumentasi & Kolaborasi Lintas Divisi', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(child: Text('100% Modul terintegrasi di Central Portal', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant))),
                    const SizedBox(width: 8),
                    Text('68%', style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.primary)),
                  ],
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(value: 0.68, backgroundColor: AppColors.surfaceContainerHigh, color: AppColors.primary, minHeight: 8, borderRadius: BorderRadius.circular(4)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.calendar_today, size: 16, color: AppColors.onSurfaceVariant),
                          const SizedBox(width: 4),
                          Flexible(child: Text('Tenggat: 31 Des 2024', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant), overflow: TextOverflow.ellipsis)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('1 KR Terhubung', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.primary)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKeyResult(BuildContext context, String title, double progress, String badgeText, Color progressColor, IconData icon, Color badgeBgColor, Color badgeTextColor) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: AppColors.surfaceContainerLowest, borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 18, color: progressColor),
              const SizedBox(width: 6),
              Expanded(child: Text(title, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600))),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: badgeBgColor, borderRadius: BorderRadius.circular(16)),
                child: Text(badgeText, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: badgeTextColor)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(value: progress, backgroundColor: AppColors.surfaceContainerHigh, color: progressColor, minHeight: 6, borderRadius: BorderRadius.circular(4)),
        ],
      ),
    );
  }

  Widget _buildKpiAnalysisSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
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
                      const Icon(Icons.bar_chart, color: AppColors.primary, size: 22),
                      const SizedBox(width: 8),
                      Flexible(child: Text('Tren Pencapaian KPI Bulanan', style: Theme.of(context).textTheme.titleMedium, overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: AppColors.secondaryContainer, borderRadius: BorderRadius.circular(16)),
                  child: Text('S2 2024', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSecondaryContainer)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 144,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(color: AppColors.surfaceContainerLow.withOpacity(0.6), borderRadius: BorderRadius.circular(12)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildChartBar(context, '82.0', 'Jul', 0.70, false),
                  _buildChartBar(context, '84.2', 'Agt', 0.75, false),
                  _buildChartBar(context, '86.0', 'Sep', 0.80, false),
                  _buildChartBar(context, '87.5', 'Okt', 0.86, true),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text('RINCIAN ASPEK PENILAIAN', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant, letterSpacing: 1.2)),
            const SizedBox(height: 8),
            _buildKpiAspect(context, 'Kualitas Output Desain', 'Bobot: 40%', '92%', 'Unggul', AppColors.primaryFixed, AppColors.primary, Icons.verified, AppColors.secondary),
            const SizedBox(height: 8),
            _buildKpiAspect(context, 'Ketepatan Waktu (SLA)', 'Bobot: 35%', '88%', 'Tepat Waktu', AppColors.secondaryContainer, AppColors.onSecondaryContainer, Icons.schedule, AppColors.secondary),
            const SizedBox(height: 8),
            _buildKpiAspect(context, 'Kolaborasi & Komunikasi', 'Bobot: 25%', '85%', 'Baik', AppColors.surfaceContainerHigh, AppColors.onSurfaceVariant, Icons.groups, AppColors.primary),
          ],
        ),
      ),
    );
  }

  Widget _buildChartBar(BuildContext context, String value, String label, double heightFraction, bool isActive) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(value, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: isActive ? AppColors.primary : AppColors.onSurfaceVariant)),
        const SizedBox(height: 6),
        Container(
          width: 36,
          height: 100 * heightFraction,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.primaryFixed,
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            boxShadow: isActive ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)] : null,
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: isActive ? AppColors.primary : AppColors.onSurfaceVariant)),
      ],
    );
  }

  Widget _buildKpiAspect(BuildContext context, String title, String weight, String score, String status, Color iconBgColor, Color iconColor, IconData icon, Color statusColor) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(color: iconBgColor, borderRadius: BorderRadius.circular(8)),
                  child: Icon(icon, color: iconColor, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: Theme.of(context).textTheme.titleSmall, overflow: TextOverflow.ellipsis),
                      Text(weight, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(score, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: statusColor)),
              Text(status, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: statusColor)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWorkPlanSection(BuildContext context) {
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
                      const Icon(Icons.checklist, color: AppColors.primary, size: 22),
                      const SizedBox(width: 8),
                      Flexible(child: Text('Rencana Kerja Oktober', style: Theme.of(context).textTheme.titleMedium, overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text('3 / 5 Selesai', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.primary)),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: 0.60, backgroundColor: AppColors.surfaceContainerHigh, color: AppColors.secondary, minHeight: 8, borderRadius: BorderRadius.circular(4)),
            const SizedBox(height: 12),
            _buildWorkPlanItem(context, 'Audit kontras warna WCAG 2.1 seluruh komponen', true),
            const SizedBox(height: 8),
            _buildWorkPlanItem(context, 'Release UI Kit Figma versi 2.4 ke pengembang', true),
            const SizedBox(height: 8),
            _buildWorkPlanItem(context, 'Penyusunan panduan interaksi mobile micro-delight', false),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkPlanItem(BuildContext context, String title, bool isCompleted) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: isCompleted ? AppColors.surfaceContainerLow : AppColors.surfaceContainerLowest, borderRadius: BorderRadius.circular(8), boxShadow: isCompleted ? null : [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4)]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Icon(isCompleted ? Icons.check_box : Icons.check_box_outline_blank, color: isCompleted ? AppColors.secondary : AppColors.primary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(decoration: isCompleted ? TextDecoration.lineThrough : null, fontWeight: isCompleted ? FontWeight.normal : FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          if (!isCompleted)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: AppColors.primaryFixed, borderRadius: BorderRadius.circular(16)),
              child: Text('Diproses', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.primary)),
            )
          else
            Text('OKR 1', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant)),
        ],
      ),
    );
  }

  Widget _buildFooterActions(BuildContext context) {
    return Column(
      children: [
        FilledButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.picture_as_pdf, size: 20),
          label: const Text('Unduh Rapor Kinerja Q4 (PDF)'),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.surfaceContainerHigh,
            foregroundColor: AppColors.primary,
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 8),
        Text('Terakhir diselaraskan otomatis dengan database HRIS: Hari ini, 09:15 WIB', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant), textAlign: TextAlign.center),
      ],
    );
  }
}
