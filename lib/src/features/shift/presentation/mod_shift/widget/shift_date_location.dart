import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/widget/custom_list_tile.dart';
import 'package:the_helper/src/common/widget/overflow_text.dart';
import 'package:the_helper/src/features/location/domain/location.dart';
import 'package:the_helper/src/utils/location.dart';

class ShiftDateLocation extends StatelessWidget {
  final DateTime? startTime;
  final DateTime? endTime;
  final Location? location;

  const ShiftDateLocation({
    super.key,
    this.startTime,
    this.endTime,
    this.location,
  });

  @override
  Widget build(BuildContext context) {
    final startTimeFormat = startTime != null
        ? DateFormat('EEE dd/MM, yyyy').format(startTime!)
        : null;
    final shortStartTimeFormat =
        startTime != null ? DateFormat('dd/MM/yyyy').format(startTime!) : null;
    final endTimeFormat =
        endTime != null ? DateFormat('EEE dd/MM, yyyy').format(endTime!) : null;
    final shortEndTimeFormat =
        endTime != null ? DateFormat('dd/MM/yyyy').format(endTime!) : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomListTile(
          leading: const Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.calendar_month_outlined),
          ),
          title: const Text('Date'),
          subtitle: OverflowText(
            text: Text(
              startTimeFormat != null
                  ? (endTimeFormat != null
                      ? '$startTimeFormat - $endTimeFormat'
                      : startTimeFormat)
                  : 'Date not set',
              style: TextStyle(color: context.theme.colorScheme.secondary),
            ),
            fallback: Text(
              shortStartTimeFormat != null
                  ? (shortEndTimeFormat != null
                      ? '$shortStartTimeFormat - $shortEndTimeFormat'
                      : shortStartTimeFormat)
                  : 'Date not set',
              style: TextStyle(color: context.theme.colorScheme.secondary),
            ),
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
