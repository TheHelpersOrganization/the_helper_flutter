import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/features/activity/presentation/activity_detail/widget/shift_action_dialog/cancel_join_shift_dialog.dart';
import 'package:the_helper/src/features/activity/presentation/activity_detail/widget/shift_action_dialog/join_shift_dialog.dart';
import 'package:the_helper/src/features/activity/presentation/activity_detail/widget/shift_action_dialog/leave_shift_dialog.dart';
import 'package:the_helper/src/features/activity/presentation/activity_detail/widget/shift_card/shift_card_footer.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';
import 'package:the_helper/src/features/shift_volunteer/domain/shift_volunteer.dart';
import 'package:the_helper/src/router/router.dart';

class ShiftCard extends StatelessWidget {
  final Shift shift;
  final ShiftVolunteer? volunteer;

  const ShiftCard({
    super.key,
    required this.shift,
    this.volunteer,
  });

  @override
  Widget build(BuildContext context) {
    final volunteerStatus = volunteer?.status;
    final String buttonLabel;
    if (volunteerStatus == ShiftVolunteerStatus.pending) {
      buttonLabel = 'Cancel registration';
    } else if (volunteerStatus == ShiftVolunteerStatus.approved) {
      buttonLabel = 'Leave';
    } else {
      buttonLabel = 'Join';
    }

    final String? volunteerDescription;
    if (volunteerStatus == ShiftVolunteerStatus.pending) {
      volunteerDescription =
          'Registered at ${DateFormat('hh:mm dd/MM/yyyy').format(volunteer!.createdAt)}';
    } else if (volunteerStatus == ShiftVolunteerStatus.approved) {
      volunteerDescription =
          'Approved at ${DateFormat('hh:mm dd/MM/yyyy').format(volunteer!.updatedAt)}';
    } else if (volunteerStatus == ShiftVolunteerStatus.rejected) {
      volunteerDescription =
          'You have been rejected at ${DateFormat('hh:mm dd/MM/yyyy').format(volunteer!.updatedAt)}';
    } else {
      volunteerDescription = null;
    }

    final shiftIsFull = shift.numberOfParticipants != null &&
        shift.joinedParticipants >= shift.numberOfParticipants!;

    final VoidCallback buttonAction;
    if (volunteerStatus == ShiftVolunteerStatus.pending) {
      buttonAction = () {
        showDialog(
          context: context,
          builder: (buildContext) => CancelJoinShiftDialog(
            activityId: shift.activityId,
            shiftId: shift.id,
            shiftName: shift.name,
          ),
        );
      };
    } else if (volunteerStatus == ShiftVolunteerStatus.approved) {
      buttonAction = () {
        showDialog(
          context: context,
          builder: (buildContext) => LeaveShiftDialog(
            activityId: shift.activityId,
            shiftId: shift.id,
            shiftName: shift.name,
          ),
        );
      };
    } else {
      buttonAction = () {
        showDialog(
          context: context,
          builder: (buildContext) => JoinShiftDialog(
            activityId: shift.activityId,
            shiftId: shift.id,
            shiftName: shift.name,
          ),
        );
      };
    }

    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 8),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {
          context.pushNamed(AppRoute.shift.name, pathParameters: {
            'activityId': shift.activityId.toString(),
            'shiftId': shift.id.toString(),
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.calendar_month_outlined,
                    size: 16,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    DateFormat('hh:mm dd/MM/yyyy').format(shift.startTime),
                    style: context.theme.textTheme.labelLarge?.copyWith(
                      color: context.theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  shift.name,
                  style: context.theme.textTheme.bodyLarge
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  shift.description ?? 'No description',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.theme.textTheme.bodyMedium?.copyWith(
                    color: context.theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              ShiftCardSkill(skills: shift.shiftSkills!),
              if (volunteerDescription != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    volunteerDescription,
                    style: context.theme.textTheme.bodyMedium?.copyWith(
                      color: context.theme.colorScheme.secondary,
                    ),
                  ),
                )
              else
                const SizedBox(
                  height: 24,
                ),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.tonal(
                      onPressed: shiftIsFull ? null : buttonAction,
                      child: Text(buttonLabel),
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
