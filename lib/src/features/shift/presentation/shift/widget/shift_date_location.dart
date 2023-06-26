import 'package:flutter/material.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/extension/date_time.dart';
import 'package:the_helper/src/common/widget/custom_list_tile.dart';
import 'package:the_helper/src/features/location/domain/location.dart';
import 'package:the_helper/src/utils/location.dart';

class ShiftDateLocation extends StatelessWidget {
  final DateTime startTime;
  final DateTime endTime;
  final Location? location;

  const ShiftDateLocation({
    super.key,
    required this.startTime,
    required this.endTime,
    this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomListTile(
          leading: const Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.calendar_month_outlined),
          ),
          title: const Text('Date'),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                startTime.formatDayMonthYear(),
                style: TextStyle(color: context.theme.colorScheme.secondary),
              ),
              Text(
                '${startTime.formatHourSecond()} - ${endTime.formatHourSecond()}',
                style: TextStyle(color: context.theme.colorScheme.secondary),
              )
            ],
          ),
        ),
        CustomListTile(
          leading: const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.location_on_outlined),
          ),
          title: const Text('Location'),
          subtitle: Text(
            getAddress(location),
            style: TextStyle(color: context.theme.colorScheme.secondary),
          ),
        ),
      ],
    );
  }
}
