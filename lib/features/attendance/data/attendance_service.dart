import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../auth/data/auth_service.dart';

class AttendanceService {
  static Future<Map<String, dynamic>> checkIn(
    String lat,
    String lng,
    File photo,
  ) async {
    return _sendMultipartRequest('/attendance/check-in', lat, lng, photo);
  }

  static Future<Map<String, dynamic>> checkOut(
    String lat,
    String lng,
    File? photo,
  ) async {
    return _sendMultipartRequest('/attendance/check-out', lat, lng, photo);
  }

  static Future<Map<String, dynamic>> _sendMultipartRequest(
    String endpoint,
    String lat,
    String lng,
    File? photo,
  ) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) {
        return {
          'success': false,
          'message': 'Sesi telah berakhir. Silakan login kembali.',
        };
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${AuthService.baseUrl}$endpoint'),
      );
      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      request.fields['latitude'] = lat;
      request.fields['longitude'] = lng;

      if (photo != null) {
        request.files.add(
          await http.MultipartFile.fromPath('photo', photo.path),
        );
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      try {
        final data = jsonDecode(response.body);

        if (data['distance'] != null) {
          // Gunakan 'num' alih-alih 'int' karena kadang PHP (backend) mengembalikan format desimal/double (contoh: 15.0)
          final num jarak = data['distance'];
          print('Jarak user saat ini: $jarak meter');
        }

        if (response.statusCode == 200 || response.statusCode == 201) {
          // Secara otomatis, data['message'] dari backend Anda sudah berisi teks jarak (contoh: "Berhasil absen masuk. (Jarak: 15 meter)")
          return {
            'success': true,
            'message': data['message'] ?? 'Berhasil',
            'data': data['data'],
          };
        } else {
          return {
            'success': false,
            'message': data['message'] ?? 'Terjadi kesalahan pada server.',
          };
        }
      } catch (e) {
        print(
          "Server returned HTML or non-JSON! Status: ${response.statusCode}, Body: ${response.body}",
        );
        return {
          'success': false,
          'message': 'API Error (Status ${response.statusCode}). Cek console.',
        };
      }
    } catch (e) {
      print("Attendance Error: $e");
      return {'success': false, 'message': 'Gagal: $e'};
    }
  }

  static Future<List<dynamic>> getHistory() async {
    try {
      final token = await AuthService.getToken();
      if (token == null) return [];

      final response = await http
          .get(
            Uri.parse('${AuthService.baseUrl}/attendance/history'),
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          return data['data'] ?? [];
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<Map<String, dynamic>?> getToday() async {
    try {
      final token = await AuthService.getToken();
      if (token == null) return null;

      final response = await http.get(
        Uri.parse('${AuthService.baseUrl}/attendance/today'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'];
      }
      return null;
    } catch (e) {
      print("Today Error: $e");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> getStatistics() async {
    try {
      final token = await AuthService.getToken();
      if (token == null) return null;

      final response = await http.get(
        Uri.parse('${AuthService.baseUrl}/attendance/statistics'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'];
      }
      return null;
    } catch (e) {
      print("Statistics Error: $e");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> getSummary({
    int? month,
    int? year,
  }) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) return null;

      String url = '${AuthService.baseUrl}/attendance/summary';
      if (month != null && year != null) {
        url += '?month=$month&year=$year';
      }

      print('MENGAMBIL DATA SUMMARY DARI: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          return data['data'];
        }
      }
      return null;
    } catch (e) {
      print("Summary Error: $e");
      return null;
    }
  }

  // Mengunduh raw CSV string
  static Future<String?> exportAttendanceCSV(int month, int year) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) return null;

      final response = await http.get(
        Uri.parse(
          '${AuthService.baseUrl}/attendance/export?month=$month&year=$year',
        ),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return response.body; // Raw CSV text
      }
      return null;
    } catch (e) {
      print("Export Error: $e");
      return null;
    }
  }
}
