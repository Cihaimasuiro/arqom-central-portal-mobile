import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text('Profil Saya', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildProfileHeader(context),
          const SizedBox(height: 24),
          _buildSectionTitle(context, 'Akun & Keamanan'),
          const SizedBox(height: 12),
          _buildMenuCard(
            children: [
              _buildMenuItem(context, Icons.lock_outline, 'Ubah Kata Sandi', onTap: () {}),
              _buildDivider(),
              _buildMenuItem(
                context,
                Icons.fingerprint,
                'Autentikasi Biometrik',
                trailing: Switch(
                  value: true,
                  onChanged: (v) {},
                  activeColor: AppColors.primary,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSectionTitle(context, 'Pengaturan Aplikasi'),
          const SizedBox(height: 12),
          _buildMenuCard(
            children: [
              _buildMenuItem(context, Icons.notifications_none, 'Notifikasi', onTap: () {}),
              _buildDivider(),
              _buildMenuItem(
                context,
                Icons.language,
                'Bahasa',
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Indonesia', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.primary)),
                    const SizedBox(width: 4),
                    const Icon(Icons.chevron_right, color: AppColors.outline, size: 20),
                  ],
                ),
                onTap: () {},
              ),
              _buildDivider(),
              _buildMenuItem(
                context,
                Icons.dark_mode_outlined,
                'Mode Gelap',
                trailing: Switch(
                  value: false,
                  onChanged: (v) {},
                  activeColor: AppColors.primary,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSectionTitle(context, 'Bantuan & Info'),
          const SizedBox(height: 12),
          _buildMenuCard(
            children: [
              _buildMenuItem(context, Icons.help_outline, 'Pusat Bantuan', onTap: () {}),
              _buildDivider(),
              _buildMenuItem(context, Icons.description_outlined, 'Syarat & Ketentuan', onTap: () {}),
              _buildDivider(),
              _buildMenuItem(context, Icons.info_outline, 'Versi Aplikasi', trailing: Text('1.0.0 (Build 12)', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant))),
            ],
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.logout),
            label: const Text('Keluar dari Akun'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.errorContainer,
              foregroundColor: AppColors.error,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primaryContainer, width: 4),
                image: const DecorationImage(
                  image: NetworkImage('https://lh3.googleusercontent.com/aida-public/AB6AXuB0Q-IMVSNKuWFtNzNPrDe5MMRdrwZL6lzcGQW5eh4A0YezhiNuo42Wy5rB_HhATSToWvxj_7JA35HiDHB0Mr0XJxp0Ry1KnqCnYDc2DsAJEbpVAU7OHPEE6FhgFX63QNIygT2iImmsUPEBOYaAg0EiBfcsF8yNdEyMbLNFzf1_qBrarDiPkewPslpzigw3p_ZRn3-pic1Tg924PKEcEntj4uAzhOZ1h42I9OEwCUTBF-dQMt-8LAA'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.surface, width: 2),
              ),
              child: const Icon(Icons.camera_alt, size: 16, color: AppColors.onPrimary),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Reza Mahendra',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          'Senior Mobile Developer',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(color: AppColors.primary),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            'NIK: 2024010899',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
          ),
    );
  }

  Widget _buildMenuCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String title, {
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 20, color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),
                ),
              ),
              if (trailing != null)
                trailing
              else if (onTap != null)
                const Icon(Icons.chevron_right, color: AppColors.outline, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: AppColors.outlineVariant.withOpacity(0.3),
      indent: 56, // Menyesuaikan dengan ikon menu
    );
  }
}
