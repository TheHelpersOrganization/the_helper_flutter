import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/extension/date_time.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';
import 'package:the_helper/src/router/router.dart';

class BottomSheetHeadingOptions {
  final bool showDetailButton;
  final bool showShiftTime;

  const BottomSheetHeadingOptions({
    this.showDetailButton = true,
    this.showShiftTime = true,
  });
}

class BottomSheetHeading extends StatelessWidget {
  final Shift shift;
  final BottomSheetHeadingOptions options;

  const BottomSheetHeading({
    super.key,
    required this.shift,
    this.options = const BottomSheetHeadingOptions(),
  });

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
          trailing: !options.showDetailButton
              ? null
              : FilledButton.tonal(
                  onPressed: () {
                    context.pop();
                    context.pushNamed(AppRoute.shift.name, pathParameters: {
                      'activityId': shift.activityId.toString(),
                      'shiftId': shift.id.toString(),
                    });
                  },
                  child: const Text('Detail'),
                ),
        ),
        if (options.showShiftTime)
          ListTile(
            leading: const Icon(Icons.access_time_outlined),
            title: const Text('Shift time'),
            subtitle: Text(
              '${shift.startTime.formatDayMonthYearBulletHourMinute()} 🡒 ${shift.endTime.formatHourSecond()}',
            ),
          ),
      ],
    );
  }
}
