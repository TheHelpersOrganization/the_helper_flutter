import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/features/shift/presentation/my_shift/controller/my_shift_controller.dart';
import 'package:the_helper/src/features/shift/presentation/my_shift/widget/bottom_sheet_heading.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';
import 'package:the_helper/src/features/shift/domain/shift_volunteer.dart';

class UpcomingShiftBottomSheet extends ConsumerWidget {
  final Shift shift;
  final ShiftVolunteer myVolunteer;

  const UpcomingShiftBottomSheet({
    super.key,
    required this.shift,
    required this.myVolunteer,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BottomSheetHeading(shift: shift),
        const Divider(),
        if (myVolunteer.status == ShiftVolunteerStatus.pending)
          ListTile(
            leading: const Icon(Icons.cancel_outlined),
            title: const Text('Cancel registration'),
            textColor: Colors.red,
            iconColor: Colors.red,
            onTap: () async {
              await ref
                  .read(cancelShiftRegistrationControllerProvider.notifier)
                  .cancelShiftRegistration(shiftId: shift.id);
              if (context.mounted) {
                context.pop();
              }
            },
          )
        else if (myVolunteer.status == ShiftVolunteerStatus.approved)
          ListTile(
            leading: const Icon(Icons.logout_outlined),
            title: const Text('Leave'),
            textColor: Colors.red,
            iconColor: Colors.red,
            onTap: () async {
              await ref
                  .read(leaveShiftControllerProvider.notifier)
                  .leaveShift(shiftId: shift.id);
              if (context.mounted) {
                context.pop();
              }
            },
          )
      ],
    );
  }
}
