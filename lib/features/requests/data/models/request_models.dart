import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class RequestItem {
  final int id;
  final String requestNumber;
  final String requestType; // cuti, izin, sakit, lembur, perjalanan_dinas
  final String title;
  final String description;
  final String startDate;
  final String? endDate;
  final String? startTime;
  final String? endTime;
  final String? location;
  final String? attachmentUrl;
  final String status; // Menunggu Manager, Menunggu HCGA, Disetujui, Ditolak, Dibatalkan
  final ApprovalInfo? managerApproval;
  final ApprovalInfo? hcgaApproval;
  final String? submittedAt;
  final EmployeeInfo? employee;

  RequestItem({
    required this.id,
    required this.requestNumber,
    required this.requestType,
    required this.title,
    required this.description,
    required this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
    this.location,
    this.attachmentUrl,
    required this.status,
    this.managerApproval,
    this.hcgaApproval,
    this.submittedAt,
    this.employee,
  });

  factory RequestItem.fromJson(Map<String, dynamic> json) {
    return RequestItem(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      requestNumber: json['request_number']?.toString() ?? '',
      requestType: json['request_type']?.toString().toLowerCase() ?? 'izin',
      title: json['title']?.toString() ?? 'Pengajuan',
      description: json['description']?.toString() ?? '',
      startDate: json['start_date']?.toString() ?? '',
      endDate: json['end_date']?.toString(),
      startTime: json['start_time']?.toString(),
      endTime: json['end_time']?.toString(),
      location: json['location']?.toString(),
      attachmentUrl: json['attachment_url']?.toString(),
      status: json['status']?.toString() ?? 'Menunggu Manager',
      managerApproval: json['manager_approval'] != null && json['manager_approval'] is Map<String, dynamic>
          ? ApprovalInfo.fromJson(json['manager_approval'] as Map<String, dynamic>)
          : null,
      hcgaApproval: json['hcga_approval'] != null && json['hcga_approval'] is Map<String, dynamic>
          ? ApprovalInfo.fromJson(json['hcga_approval'] as Map<String, dynamic>)
          : null,
      submittedAt: json['submitted_at']?.toString(),
      employee: json['employee'] != null && json['employee'] is Map<String, dynamic>
          ? EmployeeInfo.fromJson(json['employee'] as Map<String, dynamic>)
          : null,
    );
  }

  bool get canCancel {
    final s = status.toLowerCase();
    return s.contains('menunggu') || s.contains('pending');
  }

  String get typeLabel {
    switch (requestType) {
      case 'cuti':
        return 'Cuti Tahunan';
      case 'sakit':
        return 'Sakit';
      case 'izin':
        return 'Izin Ketidakhadiran';
      case 'lembur':
        return 'Kerja Lembur';
      case 'perjalanan_dinas':
      case 'dinas':
        return 'Perjalanan Dinas';
      default:
        return requestType.toUpperCase();
    }
  }

  IconData get typeIcon {
    switch (requestType) {
      case 'cuti':
        return Icons.beach_access_rounded;
      case 'sakit':
        return Icons.medical_services_rounded;
      case 'izin':
        return Icons.event_busy_rounded;
      case 'lembur':
        return Icons.access_time_filled_rounded;
      case 'perjalanan_dinas':
      case 'dinas':
        return Icons.flight_takeoff_rounded;
      default:
        return Icons.assignment_rounded;
    }
  }

  Color get typeColor {
    switch (requestType) {
      case 'cuti':
        return AppColors.primary;
      case 'sakit':
        return AppColors.error;
      case 'izin':
        return Colors.orange.shade800;
      case 'lembur':
        return Colors.indigo;
      case 'perjalanan_dinas':
      case 'dinas':
        return AppColors.tertiary;
      default:
        return AppColors.secondary;
    }
  }

  Color get statusColor {
    final s = status.toLowerCase();
    if (s.contains('disetujui')) {
      return Colors.green;
    } else if (s.contains('ditolak') || s.contains('dibatalkan')) {
      return AppColors.error;
    } else {
      return AppColors.primary;
    }
  }
}

class ApprovalInfo {
  final String status; // Menunggu, Disetujui, Ditolak
  final String? approvedBy;
  final String? approvedAt;
  final String? note;

  ApprovalInfo({
    required this.status,
    this.approvedBy,
    this.approvedAt,
    this.note,
  });

  factory ApprovalInfo.fromJson(Map<String, dynamic> json) {
    return ApprovalInfo(
      status: json['status']?.toString() ?? 'Menunggu',
      approvedBy: json['approved_by']?.toString(),
      approvedAt: json['approved_at']?.toString(),
      note: json['note']?.toString(),
    );
  }
}

class EmployeeInfo {
  final String name;
  final String email;
  final String division;
  final String position;

  EmployeeInfo({
    required this.name,
    required this.email,
    required this.division,
    required this.position,
  });

  factory EmployeeInfo.fromJson(Map<String, dynamic> json) {
    return EmployeeInfo(
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      division: json['division']?.toString() ?? '',
      position: json['position']?.toString() ?? '',
    );
  }
}
