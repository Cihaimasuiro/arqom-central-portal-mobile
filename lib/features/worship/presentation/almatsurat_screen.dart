import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../data/almatsurat_data.dart';

class AlmatsuratScreen extends StatelessWidget {
  const AlmatsuratScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> dzikirList = almatsuratData;

    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLowest,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          "Al-Ma'tsurat Sugro",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: AppColors.outlineVariant.withValues(alpha: 0.3),
            height: 1,
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        itemCount: dzikirList.length,
        separatorBuilder: (context, index) => const SizedBox(height: 24),
        itemBuilder: (context, index) {
          final dzikir = dzikirList[index];
          return _buildDzikirCard(context, dzikir, index + 1);
        },
      ),
    );
  }

  Widget _buildDzikirCard(BuildContext context, Map<String, String> dzikir, int index) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Card (Nomor dan Judul)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '#$index',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.secondaryContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.repeat, size: 12, color: AppColors.secondary),
                    const SizedBox(width: 4),
                    Text(
                      dzikir['count']!,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            dzikir['title']!,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          
          // Arabic Text
          Text(
            dzikir['arabic']!,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontFamily: 'Amiri', // Atau bisa biarkan default jika tidak menginstall font arab khusus
              fontSize: 24,
              fontWeight: FontWeight.w600,
              height: 1.8,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 24),
          
          // Latin Text (Transliteration)
          Text(
            dzikir['latin']!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.primary,
                  fontStyle: FontStyle.italic,
                  height: 1.5,
                ),
          ),
          const SizedBox(height: 12),
          Divider(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
          const SizedBox(height: 12),
          
          // Translation Text
          Text(
            dzikir['translation']!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.onSurfaceVariant,
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }
}
