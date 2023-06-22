import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/extension/date_time.dart';
import 'package:the_helper/src/features/activity/my_activity/controller/my_activity_controller.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';
import 'package:the_helper/src/features/shift/domain/shift_volunteer.dart';
import 'package:the_helper/src/router/router.dart';

class MyShiftBottomSheet extends ConsumerWidget {
  final Shift shift;
  final ShiftVolunteer myVolunteer;

  const MyShiftBottomSheet({
    super.key,
    required this.shift,
    required this.myVolunteer,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkInState = ref.watch(checkInControllerProvider);
    final checkOutState = ref.watch(checkOutControllerProvider);

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
          ListTile(
            title: Text(
              shift.name,
              style: context.theme.textTheme.bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            trailing: FilledButton.tonal(
              onPressed: () {
                context.goNamed(AppRoute.shift.name, pathParameters: {
                  'activityId': shift.activityId.toString(),
                  'shiftId': shift.id.toString(),
                });
              },
              child: const Text('Detail'),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.access_time_outlined),
            title: Text(
              '${shift.startTime.formatDayMonthYearBulletHourSecond()} 🡒 ${shift.endTime.formatHourSecond()}',
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text(
              'Check-in',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: checkInVerificationStatus,
            ),
          ),
          ListTile(
            title: Text(
              myVolunteer.checkedIn == true
                  ? 'You have checked-in'
                  : "You haven't checked-in",
            ),
            trailing: myVolunteer.checkedIn != true
                ? SizedBox(
                    width: 120,
                    child: FilledButton(
                      onPressed:
                          checkInState.isLoading || shift.me?.canCheckIn != true
                              ? null
                              : () {
                                  ref
                                      .read(checkInControllerProvider.notifier)
                                      .checkIn(
                                        shiftId: shift.id,
                                      );
                                },
                      child: const Text('Check-in'),
                    ),
                  )
                : null,
          ),
          const Divider(),
          ListTile(
            title: const Text(
              'Check-out',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: checkOutVerificationStatus,
            ),
          ),
          ListTile(
            title: Text(
              myVolunteer.checkedOut == true
                  ? 'You have checked-out'
                  : "You haven't checked-out",
            ),
            trailing: myVolunteer.checkedOut != true
                ? SizedBox(
                    width: 120,
                    child: FilledButton(
                      onPressed: checkOutState.isLoading ||
                              shift.me?.canCheckOut != true
                          ? null
                          : () {
                              ref
                                  .read(checkOutControllerProvider.notifier)
                                  .checkOut(
                                    shiftId: shift.id,
                                  );
                            },
                      child: const Text('Check-out'),
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }
}
