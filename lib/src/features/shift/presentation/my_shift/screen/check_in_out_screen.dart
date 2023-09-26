import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/features/shift/presentation/my_shift/controller/check_in_out_controller.dart';

import 'package:the_helper/src/features/activity/presentation/activity_detail/controller/activity_controller.dart';
import 'package:the_helper/src/features/activity/presentation/activity_detail/widget/shift_action_dialog/cancel_join_shift_dialog.dart';
import 'package:the_helper/src/features/activity/presentation/activity_detail/widget/shift_action_dialog/join_shift_dialog.dart';
import 'package:the_helper/src/features/activity/presentation/activity_detail/widget/shift_action_dialog/leave_shift_dialog.dart';
import 'package:the_helper/src/features/shift/domain/shift_volunteer.dart';
import 'package:the_helper/src/features/shift/presentation/shift/widget/shift_bottom_bar.dart';
import 'package:the_helper/src/features/shift/presentation/shift/widget/shift_contact.dart';
import 'package:the_helper/src/features/shift/presentation/shift/widget/shift_date_location.dart';
import 'package:the_helper/src/features/shift/presentation/shift/widget/shift_description.dart';
import 'package:the_helper/src/features/shift/presentation/shift/widget/shift_managers.dart';
import 'package:the_helper/src/features/shift/presentation/shift/widget/shift_participant.dart';
import 'package:the_helper/src/features/shift/presentation/shift/widget/shift_skill_list.dart';
import 'package:the_helper/src/features/shift/presentation/shift/widget/shift_title.dart';
import 'package:the_helper/src/features/shift/presentation/shift/widget/shift_volunteer_description.dart';

import 'package:the_helper/src/router/router.dart';
import 'package:the_helper/src/utils/async_value_ui.dart';

class CheckInOutScreen extends ConsumerWidget {
  final int shiftId;
  final bool isCheckIn;
  const CheckInOutScreen({
    required this.shiftId,
    required this.isCheckIn,
    super.key,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shift = ref.watch(shiftProvider(shiftId));
    final attendanceState = ref.watch(
        isCheckIn ? checkInControllerProvider : checkOutControllerProvider);
    ref.listen<AsyncValue>(
      isCheckIn ? checkInControllerProvider : checkOutControllerProvider  ,
      (_, state) {
        state.showSnackbarOnError(context, name: myShiftSnackbarName);
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(isCheckIn ? "Check in" : "Check out"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              shift.when(
                data: (shift) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: shift!.name,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                          children: const [
                            WidgetSpan(
                              child: SizedBox(
                                width: 8,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ShiftVolunteerDescription(
                        shift: shift,
                      ),
                      ShiftDescription(
                        description: shift.description,
                      ),
                    ],
                  );
                },
                error: (_, __) {
                  return const Text('Something wrong!');
                },
                loading: () => const CircularProgressIndicator(),
              ),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: attendanceState.isLoading
                          ? null
                          : () {
                              if (isCheckIn) {
                                print("check in");
                                ref
                                    .read(checkInControllerProvider.notifier)
                                    .checkIn(shiftId: shiftId);
                                context.pushNamed(AppRoute.home.name);
                              } else {
                                print("check out");
                                ref
                                    .read(checkOutControllerProvider.notifier)
                                    .checkOut(shiftId: shiftId);
                              }
                            },
                      child: Text(isCheckIn ? "Check in" : "Check out"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
