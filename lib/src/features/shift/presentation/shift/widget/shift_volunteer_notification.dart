import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/features/shift_volunteer/domain/shift_volunteer.dart';

class ShiftVolunteerNotification extends StatelessWidget {
  final ShiftVolunteerStatus? status;
  final DateTime? updatedAt;

  const ShiftVolunteerNotification({
    super.key,
    this.status,
    this.updatedAt,
  });

  @override
  Widget build(BuildContext context) {
    final Widget widget;

    if (status == ShiftVolunteerStatus.approved) {
      widget = Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Approved at ${DateFormat('hh:mm dd/MM/yyyy').format(updatedAt!)}',
              style: TextStyle(
                color: context.theme.colorScheme.secondary,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            const Chip(
              labelPadding: EdgeInsets.symmetric(horizontal: 4),
              padding: EdgeInsets.symmetric(horizontal: 2),
              avatar: Icon(Icons.check),
              label: Text('Approved'),
            ),
          ],
        ),
      );
    } else if (status == ShiftVolunteerStatus.pending) {
      widget = Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Registered at ${DateFormat('hh:mm dd/MM/yyyy').format(updatedAt!)}',
              style: TextStyle(
                color: context.theme.colorScheme.secondary,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const Chip(
              labelPadding: EdgeInsets.symmetric(horizontal: 4),
              padding: EdgeInsets.symmetric(horizontal: 2),
              label: Text('Waiting for approval'),
            ),
          ],
        ),
      );
    } else {
      widget = const SizedBox(
        height: 24,
      );
    }

    return widget;
  }
}
