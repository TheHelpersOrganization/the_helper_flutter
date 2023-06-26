import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/extension/date_time.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';
import 'package:the_helper/src/features/shift/domain/shift_volunteer.dart';
import 'package:the_helper/src/features/shift/presentation/shift/widget/shift_check_in_bottom_sheet.dart';
import 'package:the_helper/src/features/shift/presentation/shift/widget/shift_volunteer_notification.dart';

class ShiftVolunteerDescription extends StatelessWidget {
  final Shift shift;
  final ShiftVolunteerStatus? status;
  final DateTime? updatedAt;

  const ShiftVolunteerDescription({
    super.key,
    required this.shift,
    this.status,
    this.updatedAt,
  });

  @override
  Widget build(BuildContext context) {
    if (status == ShiftVolunteerStatus.approved) {
      return _buildApproved(context);
    } else if (status == ShiftVolunteerStatus.pending) {
      return Padding(
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
      return const SizedBox(
        height: 24,
      );
    }
  }

  showCheckInBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => ShiftCheckInBottomSheet(
        shiftId: shift.id,
      ),
      showDragHandle: true,
    );
  }

  Widget _buildApproved(BuildContext context) {
    final volunteer = shift.myShiftVolunteer!;
    final checkedInChip = Chip(
      labelPadding: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 2),
      avatar: volunteer.checkedIn == true
          ? const Icon(
              Icons.check,
              color: Colors.green,
            )
          : const Icon(
              Icons.close,
              color: Colors.red,
            ),
      label: const Text('Checked-in'),
    );
    final checkedOutChip = Chip(
      labelPadding: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 2),
      avatar: volunteer.checkedOut == true
          ? const Icon(
              Icons.check,
              color: Colors.green,
            )
          : const Icon(
              Icons.close,
              color: Colors.red,
            ),
      label: const Text('Checked-out'),
    );
    final pendingCheckedOutChip = Chip(
      labelPadding: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 2),
      avatar: volunteer.checkedOut == true
          ? const Icon(
              Icons.check,
              color: Colors.green,
            )
          : const Icon(
              Icons.pending_outlined,
            ),
      label: const Text('Checked-out'),
    );

    if (shift.status == ShiftStatus.ongoing) {
      if (volunteer.checkedOut == true) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              checkedInChip,
              const SizedBox(
                width: 8,
              ),
              checkedOutChip,
            ],
          ),
        );
      } else if (volunteer.checkedIn == true) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  checkedInChip,
                  const SizedBox(
                    width: 8,
                  ),
                  pendingCheckedOutChip,
                ],
              ),
            ],
          ),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: ShiftVolunteerNotification(
            message: "You haven't checked-in yet",
            action: TextButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => ShiftCheckInBottomSheet(
                    shiftId: shift.id,
                  ),
                  showDragHandle: true,
                );
              },
              child: const Text('Check-in'),
            ),
          ),
        );
      }
    } else if (shift.status == ShiftStatus.pending) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Approved at ${updatedAt!.formatDayMonthYearBulletHourMinute()}',
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
    } else if (shift.status == ShiftStatus.completed) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                checkedInChip,
                const SizedBox(
                  width: 8,
                ),
                shift.me?.canCheckOut == true
                    ? pendingCheckedOutChip
                    : checkedOutChip,
              ],
            ),
            if (shift.me?.canCheckOut == true)
              ShiftVolunteerNotification(
                message: "You haven't checked-out yet",
                action: TextButton(
                  onPressed: () {
                    showCheckInBottomSheet(context);
                  },
                  child: const Text('Check-out'),
                ),
              ),
          ],
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
