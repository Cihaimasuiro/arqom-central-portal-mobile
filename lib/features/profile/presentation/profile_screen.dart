import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/artech_loading_widget.dart';
import '../../auth/presentation/login_screen.dart';
import '../../auth/data/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final data = await AuthService.getUserData();
    if (mounted) {
      setState(() {
        _userData = data;
        _isLoading = false;
      });
    }
  }

  bool _isRefreshingOverlay = false;

  Future<void> _refreshData() async {
    setState(() {
      _isRefreshingOverlay = true;
    });
    await Future.wait([
      _loadUserData(),
      Future.delayed(const Duration(seconds: 1)),
    ]);
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
      body: _isLoading 
          ? const ArtechLoadingWidget.fullScreen(size: 80, message: 'Memuat profil...')
          : Stack(
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
                  _buildProfileHeader(context),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildSectionTitle(context, 'Akun & Keamanan'),
                        const SizedBox(height: 10),
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
                        const SizedBox(height: 20),
                        _buildSectionTitle(context, 'Pengaturan Aplikasi'),
                        const SizedBox(height: 10),
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
                                  Text('Indonesia', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.chevron_right, color: AppColors.outline, size: 18),
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
                        const SizedBox(height: 20),
                        _buildSectionTitle(context, 'Bantuan & Info'),
                        const SizedBox(height: 10),
                        _buildMenuCard(
                          children: [
                            _buildMenuItem(context, Icons.help_outline, 'Pusat Bantuan', onTap: () {}),
                            _buildDivider(),
                            _buildMenuItem(context, Icons.description_outlined, 'Syarat & Ketentuan', onTap: () {}),
                            _buildDivider(),
                            _buildMenuItem(context, Icons.info_outline, 'Versi Aplikasi', trailing: Text('1.0.0', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant))),
                          ],
                        ),
                        const SizedBox(height: 24),
                        OutlinedButton.icon(
                          onPressed: () async {
                            await AuthService.logout();
                            if (context.mounted) {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (_) => const LoginScreen()),
                                (route) => false,
                              );
                            }
                          },
                          icon: const Icon(Icons.logout, size: 18),
                          label: const Text('Keluar dari Akun'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.error,
                            side: const BorderSide(color: AppColors.error),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                        const SizedBox(height: 20),
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
                        child: ArtechLoadingWidget.overlayCard(
                          message: 'Memperbarui profil...',
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    final name = _userData?['name'] ?? 'Pengguna';
    final role = _userData?['position'] ?? _userData?['role'] ?? 'Staff';
    final identifier = _userData?['email'] ?? _userData?['nik'] ?? '-';
    final photoUrl = _userData?['profile_photo_url'] ?? 
        'https://ui-avatars.com/api/?name=${Uri.encodeComponent(name)}&background=0037b0&color=fff';

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
        children: [
          // Title bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Profil',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.white, size: 22),
                onPressed: () {},
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Avatar + info row
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.4), width: 3),
                ),
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(photoUrl),
                  backgroundColor: Colors.white24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      role,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white60),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.email_outlined, size: 12, color: Colors.white70),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              identifier,
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white, fontSize: 10),
                              overflow: TextOverflow.ellipsis,
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
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
          ),
    );
  }

  Widget _buildMenuCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withOpacity(0.5)),
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
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              if (trailing != null)
                trailing
              else if (onTap != null)
                const Icon(Icons.chevron_right, color: AppColors.outline, size: 18),
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
      indent: 64, // Menyesuaikan dengan ikon menu
    );
  }
}
