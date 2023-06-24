import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/extension/date_time.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';
import 'package:the_helper/src/router/router.dart';

class BottomSheetHeading extends StatelessWidget {
  final Shift shift;

  const BottomSheetHeading({super.key, required this.shift});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: Text(
            shift.name,
            style: context.theme.textTheme.bodyLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          trailing: FilledButton.tonal(
            onPressed: () {
              context.goNamed(AppRoute.shift.name, pathParameters: {
                'activityId': shift.activityId.toString(),
                'shiftId': shift.id.toString(),
              });
            },
            child: const Text('Detail'),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.access_time_outlined),
          title: const Text('Shift time'),
          subtitle: Text(
            '${shift.startTime.formatDayMonthYearBulletHourSecond()} 🡒 ${shift.endTime.formatHourSecond()}',
          ),
        ),
      ],
    );
  }
}
