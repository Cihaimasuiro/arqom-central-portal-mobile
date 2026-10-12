import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/requests_service.dart';

/// Helper to display error responses aligned with Module 5 & 6 standards:
/// - 403: Alert dialog "Akses Ditolak"
/// - 422 / others: SnackBar with descriptive feedback
void handleRequestApiError(BuildContext context, RequestApiResponse response) {
  if (response.statusCode == 403) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.gpp_bad_outlined, color: AppColors.error, size: 24),
            SizedBox(width: 8),
            Text('Akses Ditolak (403)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(
          response.message.isNotEmpty
              ? response.message
              : 'Anda tidak memiliki hak akses mengubah/menyetujui data ini.',
          style: const TextStyle(fontSize: 13, height: 1.4),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Mengerti'),
          ),
        ],
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response.message),
        backgroundColor: response.statusCode == 422 ? Colors.orange.shade800 : AppColors.error,
      ),
    );
  }
}
