import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class LiveClockWidget extends StatefulWidget {
  final TextStyle? timeStyle;
  final TextStyle? amPmStyle;

  const LiveClockWidget({
    super.key,
    this.timeStyle,
    this.amPmStyle,
  });

  @override
  State<LiveClockWidget> createState() => _LiveClockWidgetState();
}

class _LiveClockWidgetState extends State<LiveClockWidget> {
  late Timer _timer;
  late DateTime _currentTime;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _currentTime = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatTime(DateTime time) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(time.hour)}:${twoDigits(time.minute)}:${twoDigits(time.second)}';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          _formatTime(_currentTime),
          style: widget.timeStyle ?? Theme.of(context).textTheme.displayLarge,
        ),
        const SizedBox(width: 4),
        Text(
          'WIB', // Default to WIB for local time format context
          style: widget.amPmStyle ?? Theme.of(context).textTheme.labelMedium?.copyWith(color: AppColors.onSurfaceVariant),
        ),
      ],
    );
  }
}
