import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/extension/date_time.dart';
import 'package:the_helper/src/common/widget/alert.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';
import 'package:the_helper/src/router/router.dart';

class UpcomingShiftAlert extends StatelessWidget {
  final Shift upcomingShift;

  const UpcomingShiftAlert({
    Key? key,
    required this.upcomingShift,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timeDisplay = upcomingShift.startTime.isToday == true
        ? '${upcomingShift.startTime.formatHourSecond()} Today'
        : upcomingShift.startTime.isTomorrow == true
        ? '${upcomingShift.startTime.formatHourSecond()} Tomorrow'
        : upcomingShift.startTime.formatDayMonthYearBulletHourMinute() ??
        '';

    return Alert(
      leading: const Icon(
        Icons.info_outline,
      ),
      message: Wrap(
        spacing: 2,
        children: [
          Text.rich(
            TextSpan(
              text: 'Shift ',
              children: [
                TextSpan(
                  text: upcomingShift.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text.rich(
            TextSpan(
              text: 'is starting soon at ',
              children: [
                const WidgetSpan(
                  child: Icon(
                    Icons.access_time_outlined,
                    size: 16,
                  ),
                ),
                TextSpan(
                  text: ' $timeDisplay',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          )
        ],
      ),
      action: IconButton(
        onPressed: () {
          context.goNamed(AppRoute.shift.name, pathParameters: {
            'activityId': upcomingShift.activityId.toString(),
            'shiftId': upcomingShift.id.toString(),
          });
        },
        icon: const Icon(Icons.navigate_next_outlined),
      ),
    );
  }
}