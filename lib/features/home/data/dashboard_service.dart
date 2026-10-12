import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../auth/data/auth_service.dart';
import 'models/announcement.dart';
import 'models/activity.dart';

class DashboardService {
  static Future<Map<String, dynamic>> getDashboardData() async {
    try {
      final token = await AuthService.getToken();
      if (token == null) {
        return {'success': false, 'message': 'User tidak terautentikasi.'};
      }

      final response = await http.get(
        Uri.parse('${AuthService.baseUrl}/dashboard'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          final List<dynamic> rawAnnouncements = data['data']['announcements'] ?? [];
          final List<dynamic> rawActivities = data['data']['activities'] ?? [];

          return {
            'success': true,
            'announcements': rawAnnouncements.map((e) => Announcement.fromJson(e)).toList(),
            'activities': rawActivities.map((e) => Activity.fromJson(e)).toList(),
          };
        }
      }
      return {'success': false, 'message': 'Gagal mengambil data beranda.'};
    } catch (e) {
      return {'success': false, 'message': 'Gagal terhubung ke server.'};
    }
  }
}
