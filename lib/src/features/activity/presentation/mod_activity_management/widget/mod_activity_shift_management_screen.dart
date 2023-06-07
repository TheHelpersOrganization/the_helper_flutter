import 'package:flutter/material.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_management/widget/shift_card/shift_card.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';

class ModActivityShiftManagementView extends StatelessWidget {
  final List<Shift> shifts;

  const ModActivityShiftManagementView({
    super.key,
    required this.shifts,
  });

  @override
  Widget build(BuildContext context) {
    return shifts.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: shifts.map((e) => ShiftCard(shift: e)).toList(),
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
                  const Text('Tap "+ Shift" to add new shift')
                ],
              ),
            ),
          );
  }
}
