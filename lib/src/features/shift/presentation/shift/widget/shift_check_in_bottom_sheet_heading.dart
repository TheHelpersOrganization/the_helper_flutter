import 'package:flutter/material.dart';
import 'package:the_helper/src/common/extension/date_time.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';

class ShiftCheckInBottomSheetHeading extends StatelessWidget {
  final Shift shift;

  const ShiftCheckInBottomSheetHeading({super.key, required this.shift});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: Text(
            shift.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.access_time_outlined),
          title: const Text('Shift time'),
          subtitle: Text(
            '${shift.startTime.formatDayMonthYearBulletHourMinute()} --> ${shift.endTime.formatHourSecond()}',
          ),
        ),
      ],
    );
  }
}
