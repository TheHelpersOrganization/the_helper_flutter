import 'package:flutter/material.dart';
import 'package:the_helper/src/features/activity/presentation/activity_detail/widget/shift_action_dialog/cancel_join_shift_dialog.dart';
import 'package:the_helper/src/features/activity/presentation/activity_detail/widget/shift_action_dialog/join_shift_dialog.dart';
import 'package:the_helper/src/features/activity/presentation/activity_detail/widget/shift_action_dialog/leave_shift_dialog.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';
import 'package:the_helper/src/features/shift/domain/shift_volunteer.dart';
import 'package:the_helper/src/features/shift/presentation/my_shift/widget/bottom_sheet_heading.dart';
import 'package:the_helper/src/features/shift/presentation/my_shift/widget/ongoing_shift_bottom_sheet.dart';
import 'package:the_helper/src/features/shift/presentation/shift/widget/shift_check_in_bottom_sheet.dart';

class ShiftBottomBar extends StatelessWidget {
  final Shift shift;
  final ShiftVolunteer? shiftVolunteer;

  const ShiftBottomBar({
    super.key,
    required this.shift,
    required this.shiftVolunteer,
  });

  @override
  Widget build(BuildContext context) {
    final activityId = shift.id;
    final shiftId = shift.id;
    final status = shiftVolunteer?.status;
    final VoidCallback? buttonAction;
    final String? buttonLabel;
    if (shiftVolunteer == null && shift.isFull) {
      buttonAction = null;
      buttonLabel = null;
    } else if (status == ShiftVolunteerStatus.pending) {
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
      if (shift.status == ShiftStatus.pending) {
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
      } else if (shift.status == ShiftStatus.ongoing) {
        buttonAction = () {
          showModalBottomSheet(
            context: context,
            builder: (buildContext) => ShiftCheckInBottomSheet(
              shiftId: shift.id,
            ),
            showDragHandle: true,
          );
        };
        buttonLabel = 'Manage check-in';
      } else if (shift.status == ShiftStatus.completed) {
        buttonAction = () {
          showModalBottomSheet(
            context: context,
            builder: (buildContext) => OngoingShiftBottomSheet(
              initialShift: shift,
              bottomSheetHeadingOptions: const BottomSheetHeadingOptions(
                showDetailButton: false,
                showShiftTime: false,
              ),
            ),
            showDragHandle: true,
          );
        };
        buttonLabel = 'My status';
      } else {
        buttonAction = null;
        buttonLabel = null;
      }
    } else {
      buttonAction = () {
        showDialog(
          context: context,
          builder: (buildContext) => JoinShiftDialog(
            activityId: activityId,
            shiftId: shiftId,
            shift: shift,
          ),
        );
      };
      buttonLabel = 'Join';
    }

    if (buttonAction == null && buttonLabel == null) {
      return const SizedBox.shrink();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(
          height: 1,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: buttonAction,
                  child: Text(buttonLabel ?? ''),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
