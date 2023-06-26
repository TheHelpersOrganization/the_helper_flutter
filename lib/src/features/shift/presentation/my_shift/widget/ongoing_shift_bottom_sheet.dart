import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/extension/date_time.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';
import 'package:the_helper/src/features/shift/presentation/my_shift/controller/my_shift_controller.dart';
import 'package:the_helper/src/features/shift/presentation/my_shift/widget/bottom_sheet_heading.dart';
import 'package:the_helper/src/features/shift/presentation/my_shift/widget/bottom_sheet_review.dart';
import 'package:the_helper/src/features/shift/presentation/my_shift/widget/check_in_dialog.dart';
import 'package:the_helper/src/features/shift/presentation/my_shift/widget/check_out_dialog.dart';

class OngoingShiftBottomSheet extends ConsumerWidget {
  final Shift initialShift;

  const OngoingShiftBottomSheet({
    super.key,
    required this.initialShift,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkInState = ref.watch(checkInControllerProvider);
    final checkOutState = ref.watch(checkOutControllerProvider);
    final myShift =
        ref.watch(myShiftProvider(initialShift.id)).valueOrNull ?? initialShift;
    final myVolunteer = myShift.myShiftVolunteer!;
    List<Widget> checkInVerificationStatus;
    if (myVolunteer.isCheckInVerified == null) {
      checkInVerificationStatus = [
        const Icon(
          Icons.pending_outlined,
        ),
        const SizedBox(
          width: 4,
        ),
        const Text('Waiting verification')
      ];
    } else if (myVolunteer.isCheckInVerified == true) {
      checkInVerificationStatus = [
        const Icon(
          Icons.check_outlined,
          color: Colors.green,
        ),
        const SizedBox(
          width: 4,
        ),
        const Text('Verified')
      ];
    } else {
      checkInVerificationStatus = [
        const Icon(
          Icons.close_outlined,
          color: Colors.red,
        ),
        const SizedBox(
          width: 4,
        ),
        const Text('Rejected')
      ];
    }
    List<Widget> checkOutVerificationStatus;
    if (myVolunteer.isCheckOutVerified == null) {
      checkOutVerificationStatus = [
        const Icon(
          Icons.pending_outlined,
        ),
        const SizedBox(
          width: 4,
        ),
        const Text('Waiting verification')
      ];
    } else if (myVolunteer.isCheckOutVerified == true) {
      checkOutVerificationStatus = [
        const Icon(
          Icons.check_outlined,
          color: Colors.green,
        ),
        const SizedBox(
          width: 4,
        ),
        const Text('Verified')
      ];
    } else {
      checkOutVerificationStatus = [
        const Icon(
          Icons.close_outlined,
          color: Colors.red,
        ),
        const SizedBox(
          width: 4,
        ),
        const Text('Rejected')
      ];
    }

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BottomSheetHeading(shift: myShift),
          if (myShift.status == ShiftStatus.completed) ...[
            const Divider(),
            BottomSheetReview(shift: myShift, volunteer: myVolunteer),
          ],
          const Divider(),
          ListTile(
            leading: const Icon(Icons.login_outlined),
            title: const Text(
              'Check-in',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: myVolunteer.checkedIn == true ||
                    myVolunteer.isCheckInVerified != null
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: checkInVerificationStatus,
                  )
                : null,
          ),
          ListTile(
            title: myVolunteer.checkedIn == true
                ? Text.rich(
                    TextSpan(
                      text: 'You have checked-in at ',
                      children: [
                        TextSpan(
                          text: myVolunteer.checkInAt
                              ?.formatDayMonthYearBulletHourMinute(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    style: context.theme.textTheme.bodyMedium,
                  )
                : Text(
                    "You haven't checked-in",
                    style: context.theme.textTheme.bodyMedium,
                  ),
            trailing: (myShift.status == ShiftStatus.ongoing &&
                        myVolunteer.checkedIn != true) ||
                    (myShift.status == ShiftStatus.completed &&
                        myShift.me?.canCheckIn == true)
                ? SizedBox(
                    width: 120,
                    child: FilledButton(
                      onPressed: checkInState.isLoading ||
                              myShift.me?.canCheckIn != true
                          ? null
                          : () {
                              // ref
                              //     .read(checkInControllerProvider.notifier)
                              //     .checkIn(
                              //       shiftId: myShift.id,
                              //     );
                              showDialog(
                                context: context,
                                builder: (context) => CheckInDialog(
                                  shift: myShift,
                                ),
                              );
                            },
                      child: const Text('Check-in'),
                    ),
                  )
                : null,
          ),
          if (myVolunteer.checkedIn == true ||
              myShift.status == ShiftStatus.completed)
            const Divider(),
          if (myVolunteer.checkedIn == true ||
              myShift.status == ShiftStatus.completed)
            ListTile(
              leading: const Icon(Icons.logout_outlined),
              title: const Text(
                'Check-out',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: myVolunteer.checkedOut == true ||
                      myVolunteer.isCheckOutVerified != null
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: checkOutVerificationStatus,
                    )
                  : null,
            ),
          if (myVolunteer.checkedIn == true ||
              myShift.status == ShiftStatus.completed)
            ListTile(
              title: myVolunteer.checkedOut == true
                  ? Text.rich(
                      TextSpan(
                        text: 'You have checked-out at ',
                        children: [
                          TextSpan(
                            text:
                                '${myVolunteer.checkOutAt?.formatDayMonthYearBulletHourMinute()}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      style: context.theme.textTheme.bodyMedium,
                    )
                  : Text(
                      "You haven't checked-out",
                      style: context.theme.textTheme.bodyMedium,
                    ),
              trailing: (myShift.status == ShiftStatus.ongoing &&
                          myVolunteer.checkedOut != true) ||
                      (myShift.status == ShiftStatus.completed &&
                          myShift.me?.canCheckOut == true)
                  ? SizedBox(
                      width: 120,
                      child: FilledButton(
                        onPressed: checkOutState.isLoading ||
                                myShift.me?.canCheckOut != true
                            ? null
                            : () {
                                // ref
                                //     .read(checkOutControllerProvider.notifier)
                                //     .checkOut(
                                //       shiftId: myShift.id,
                                //     );
                                showDialog(
                                  context: context,
                                  builder: (context) => CheckOutDialog(
                                    shift: myShift,
                                  ),
                                );
                              },
                        child: const Text('Check-out'),
                      ),
                    )
                  : null,
            ),
          const SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }
}
