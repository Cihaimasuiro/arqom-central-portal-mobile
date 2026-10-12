import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../../core/theme/app_colors.dart';
import '../data/attendance_service.dart';

class AttendanceHistoryScreen extends StatefulWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  State<AttendanceHistoryScreen> createState() => _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
  DateTime _selectedMonth = DateTime.now();
  bool _isLoading = false;
  Map<String, dynamic>? _summaryData;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null).then((_) {
      _fetchData();
    });
  }

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);
    
    final int month = _selectedMonth.month;
    final int year = _selectedMonth.year;
    
    final data = await AttendanceService.getSummary(month: month, year: year);
    
    setState(() {
      _summaryData = data;
      _isLoading = false;
    });
  }

  void _previousMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
    });
    _fetchData();
  }

  void _nextMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
    });
    _fetchData();
  }

  Color _getColorFromCode(String colorCode) {
    switch (colorCode.toLowerCase()) {
      case 'green':
        return AppColors.secondary;
      case 'orange':
        return Colors.orange[700]!;
      case 'red':
        return AppColors.error;
      case 'transparent':
        return Colors.transparent;
      default:
        return AppColors.onSurfaceVariant;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String monthDisplay = DateFormat('MMMM yyyy', 'id_ID').format(_selectedMonth);
    
    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLowest,
      appBar: AppBar(
        title: const Text('Riwayat Absensi'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Month Selector
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: AppColors.surfaceContainerLowest,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left, color: AppColors.primary),
                  onPressed: _previousMonth,
                ),
                Text(
                  monthDisplay,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right, color: AppColors.primary),
                  onPressed: _nextMonth,
                ),
              ],
            ),
          ),
          
          Expanded(
            child: _isLoading 
                ? const Center(child: CircularProgressIndicator())
                : _summaryData == null
                    ? const Center(child: Text('Gagal memuat data.'))
                    : _buildContent(context),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final summary = _summaryData?['summary'] ?? {};
    final List<dynamic> calendar = _summaryData?['calendar'] ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Summary Stats
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 2.2,
            children: [
              _buildStatCard('Hadir', summary['present']?.toString() ?? '0', Icons.check_circle_outline, AppColors.secondary),
              _buildStatCard('Telat', summary['late']?.toString() ?? '0', Icons.schedule, Colors.orange[700]!),
              _buildStatCard('Cuti', summary['leave']?.toString() ?? '0', Icons.beach_access, AppColors.primary),
              _buildStatCard('Alfa', summary['absent']?.toString() ?? '0', Icons.cancel_outlined, AppColors.error),
            ],
          ),
          const SizedBox(height: 24),
          
          Text(
            'Rincian Kehadiran',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          
          // Calendar List
          if (calendar.isEmpty)
            const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: Text('Belum ada riwayat pada bulan ini.')),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: calendar.length,
              itemBuilder: (context, index) {
                final item = calendar[index];
                final bool isTransparent = item['color_code'] == 'transparent';
                final Color statusColor = _getColorFromCode(item['color_code'] ?? '');
                
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: AppColors.outlineVariant.withValues(alpha: 0.2), blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Date Indicator
                      Container(
                        width: 70,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: isTransparent ? AppColors.surfaceContainerHigh : statusColor.withValues(alpha: 0.1),
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(item['day_name'] ?? '-', style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold, color: isTransparent ? AppColors.onSurfaceVariant : statusColor)),
                            const SizedBox(height: 4),
                            Text(item['date'] != null ? item['date'].split('-').last : '-', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: isTransparent ? AppColors.onSurfaceVariant : statusColor)),
                          ],
                        ),
                      ),
                      
                      const SizedBox(width: 16),
                      
                      // Details
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Status Badge
                              if (!isTransparent)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  margin: const EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(20)),
                                  child: Text(item['status'] ?? '-', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                                )
                              else
                                Text(item['status'] ?? '-', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant)),
                                
                              if (!isTransparent) ...[
                                Row(
                                  children: [
                                    Icon(Icons.login, size: 14, color: AppColors.onSurfaceVariant.withValues(alpha: 0.7)),
                                    const SizedBox(width: 4),
                                    Text(item['check_in'] ?? '--:--', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                                    const SizedBox(width: 16),
                                    Icon(Icons.logout, size: 14, color: AppColors.onSurfaceVariant.withValues(alpha: 0.7)),
                                    const SizedBox(width: 4),
                                    Text(item['check_out'] ?? '--:--', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: color)),
              const SizedBox(height: 2),
              Text(label, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color, fontWeight: FontWeight.bold)),
            ],
          ),
          Icon(icon, color: color.withValues(alpha: 0.5), size: 32),
        ],
      ),
    );
  }
}
