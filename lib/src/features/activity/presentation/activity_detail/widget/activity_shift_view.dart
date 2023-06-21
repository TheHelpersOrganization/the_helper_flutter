import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/features/activity/presentation/activity_detail/widget/shift_card/shift_card.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';
import 'package:the_helper/src/features/shift/domain/shift_volunteer.dart';

class ActivityShiftView extends StatelessWidget {
  final List<Shift> shifts;
  final List<ShiftVolunteer> volunteers;
  final Map<int, ShiftVolunteer> groupedVolunteers = {};

  ActivityShiftView({
    super.key,
    required this.shifts,
    required this.volunteers,
  }) {
    volunteers.forEachIndexed((index, element) {
      if (groupedVolunteers.containsKey(element.shiftId)) {
        final exist = groupedVolunteers[element.shiftId]!;
        if (exist.updatedAt.isBefore(element.updatedAt)) {
          groupedVolunteers[element.shiftId] = element;
        }
      } else {
        groupedVolunteers[element.shiftId] = element;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return shifts.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: shifts
                .map(
                  (e) => ShiftCard(
                    shift: e,
                    volunteer: groupedVolunteers[e.id],
                  ),
                )
                .toList(),
          )
        : Padding(
            padding: const EdgeInsets.all(12),
            child: Center(
              child: Column(
                children: [
                  Text(
                    'No shift found',
                    style: TextStyle(
                      color: context.theme.colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
