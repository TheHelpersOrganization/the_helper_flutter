import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/screens/screen404.dart';
import 'package:the_helper/src/common/widget/error_widget.dart';
import 'package:the_helper/src/features/activity/presentation/activity_detail/controller/activity_controller.dart';
import 'package:the_helper/src/features/activity/presentation/activity_detail/widget/shift_action_dialog/cancel_join_shift_dialog.dart';
import 'package:the_helper/src/features/activity/presentation/activity_detail/widget/shift_action_dialog/join_shift_dialog.dart';
import 'package:the_helper/src/features/activity/presentation/activity_detail/widget/shift_action_dialog/leave_shift_dialog.dart';
import 'package:the_helper/src/features/shift/domain/shift_volunteer.dart';
import 'package:the_helper/src/features/shift/presentation/shift/controller/shift_controller.dart';
import 'package:the_helper/src/features/shift/presentation/shift/widget/shift_bottom_bar.dart';
import 'package:the_helper/src/features/shift/presentation/shift/widget/shift_contact.dart';
import 'package:the_helper/src/features/shift/presentation/shift/widget/shift_date_location.dart';
import 'package:the_helper/src/features/shift/presentation/shift/widget/shift_description.dart';
import 'package:the_helper/src/features/shift/presentation/shift/widget/shift_managers.dart';
import 'package:the_helper/src/features/shift/presentation/shift/widget/shift_participant.dart';
import 'package:the_helper/src/features/shift/presentation/shift/widget/shift_skill_list.dart';
import 'package:the_helper/src/features/shift/presentation/shift/widget/shift_title.dart';
import 'package:the_helper/src/features/shift/presentation/shift/widget/shift_volunteer_description.dart';
import 'package:the_helper/src/utils/async_value_ui.dart';

class ShiftScreen extends ConsumerWidget {
  final int activityId;
  final int shiftId;

  const ShiftScreen({
    super.key,
    required this.activityId,
    required this.shiftId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activityAndShiftState = ref.watch(
      getActivityAndShiftProvider(
        shiftId,
      ),
    );

    ref.listen<AsyncValue>(
      joinShiftControllerProvider,
      (_, state) {
        state.showSnackbarOnError(
          context,
          name: shiftSnackbarName,
        );
        state.showSnackbarOnSuccess(
          context,
          content: const Text('Shift registered successfully'),
          name: shiftSnackbarName,
        );
      },
    );
    ref.listen<AsyncValue>(
      cancelJoinShiftControllerProvider,
      (_, state) {
        state.showSnackbarOnError(
          context,
          name: shiftSnackbarName,
        );
        state.showSnackbarOnSuccess(
          context,
          content: const Text('Shift registration cancelled successfully'),
          name: shiftSnackbarName,
        );
      },
    );
    ref.listen<AsyncValue>(
      leaveShiftControllerProvider,
      (_, state) {
        state.showSnackbarOnError(
          context,
          name: shiftSnackbarName,
        );
        state.showSnackbarOnSuccess(
          context,
          content: const Text('Leave shift successfully'),
          name: shiftSnackbarName,
        );
      },
    );

    final shiftVolunteer =
        activityAndShiftState.valueOrNull?.latestShiftVolunteer;
    final status = shiftVolunteer?.status;
    final VoidCallback? buttonAction;
    final String? buttonLabel;
    if (status == null) {
      buttonAction = null;
      buttonLabel = null;
    } else {
      if (status == ShiftVolunteerStatus.pending) {
        buttonAction = () {
          showDialog(
            context: context,
            builder: (buildContext) => CancelJoinShiftDialog(
              activityId: activityId,
              shiftId: shiftId,
            ),
          );
        };
        buttonLabel = 'Cancel registration';
      } else if (status == ShiftVolunteerStatus.approved) {
        buttonAction = () {
          showDialog(
            context: context,
            builder: (buildContext) => LeaveShiftDialog(
              activityId: activityId,
              shiftId: shiftId,
            ),
          );
        };
        buttonLabel = 'Leave';
      } else {
        buttonAction = () {
          showDialog(
            context: context,
            builder: (buildContext) => JoinShiftDialog(
              activityId: activityId,
              shiftId: shiftId,
            ),
          );
        };
        buttonLabel = 'Join';
      }
    }

    return Scaffold(
      body: activityAndShiftState.when(
        skipLoadingOnRefresh: false,
        error: (_, __) => CustomErrorWidget(
          onRetry: () => ref.invalidate(getActivityAndShiftProvider),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        data: (activityAndShift) {
          if (activityAndShift == null ||
              activityAndShift.activity.id != activityId) {
            return const DevelopingScreen();
          }
          final activity = activityAndShift.activity;
          final shift = activityAndShift.shift;
          final volunteer = activityAndShift.latestShiftVolunteer;

          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              const SliverAppBar(
                title: Text('Shift'),
                floating: true,
              ),
            ],
            body: Padding(
              padding: const EdgeInsets.all(12.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShiftTitle(activity: activity, shift: shift),
                    ShiftVolunteerDescription(
                      shift: shift,
                    ),
                    ShiftDescription(
                      description: shift.description,
                    ),
                    const SizedBox(
                      height: 48,
                    ),
                    ShiftParticipant(
                      joinedParticipants: shift.joinedParticipants,
                      numberOfParticipants: shift.numberOfParticipants,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    ShiftDateLocation(
                      startTime: shift.startTime,
                      endTime: shift.endTime,
                      location: shift.locations?.isNotEmpty == true
                          ? shift.locations?.first
                          : null,
                    ),
                    const SizedBox(
                      height: 48,
                    ),
                    ShiftSkillList(
                      skills: shift.shiftSkills,
                    ),
                    const SizedBox(
                      height: 48,
                    ),
                    ShiftContact(contacts: shift.contacts),
                    const SizedBox(
                      height: 48,
                    ),
                    ShiftManagers(
                      managers: shift.shiftManagers,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: activityAndShiftState.valueOrNull?.shift == null
          ? null
          : ShiftBottomBar(
              shift: activityAndShiftState.value!.shift,
              shiftVolunteer: shiftVolunteer,
            ),
    );
  }
}
