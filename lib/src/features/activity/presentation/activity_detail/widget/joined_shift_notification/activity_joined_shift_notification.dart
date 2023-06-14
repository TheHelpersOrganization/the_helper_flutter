import 'package:flutter/material.dart';
import 'package:the_helper/src/common/extension/build_context.dart';

class ActivityJoinedShiftNotification extends StatelessWidget {
  final int pendingShiftsCount;
  final int approvedShiftsCount;

  const ActivityJoinedShiftNotification({
    super.key,
    required this.pendingShiftsCount,
    required this.approvedShiftsCount,
  });

  @override
  Widget build(BuildContext context) {
    String label = 'You have';
    if (pendingShiftsCount > 0) {
      label += ' $pendingShiftsCount registrations waiting for approval';
    }
    if (approvedShiftsCount > 0) {
      if (pendingShiftsCount > 0) {
        label += ' and';
      }
      label += ' $approvedShiftsCount approved registrations';
    }

    return Text(
      label,
      style: TextStyle(color: context.theme.colorScheme.secondary),
    );
  }
}
