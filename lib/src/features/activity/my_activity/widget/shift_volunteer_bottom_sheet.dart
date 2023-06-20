import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/extension/widget.dart';
import 'package:the_helper/src/features/activity/my_activity/widget/label.dart';
import 'package:the_helper/src/features/activity/presentation/activity_detail/widget/shift_action_dialog/cancel_join_shift_dialog.dart';
import 'package:the_helper/src/features/activity/presentation/activity_detail/widget/shift_action_dialog/leave_shift_dialog.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';
import 'package:the_helper/src/features/shift_volunteer/domain/shift_volunteer.dart';
import 'package:the_helper/src/router/router.dart';

class ShiftVolunteerBottomSheet extends ConsumerWidget {
  final ShiftVolunteer volunteer;
  final Shift shift;

  const ShiftVolunteerBottomSheet({
    super.key,
    required this.volunteer,
    required this.shift,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  shift.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              if (shift.status == ShiftStatus.completed)
                (volunteer.attendant)
                    ? const Label(labelText: 'Attended', color: Colors.green)
                    : const Label(labelText: 'Absent', color: Colors.red)
            ],
          ),
        ),
        if (shift.status == ShiftStatus.completed)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Completion rate: ${(volunteer.completion * 100).toStringAsFixed(1)}%',
              style: context.theme.textTheme.bodyLarge,
            ),
          ),
        if (shift.status == ShiftStatus.completed && volunteer.attendant)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: shift.shiftSkills
                        ?.map(
                          (e) => Chip(
                            labelPadding: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            avatar: const Icon(
                              Icons.wb_sunny_outlined,
                              size: 20,
                            ),
                            label: Text(
                                '${e.skill?.name ?? ''} +${(e.hours! * volunteer.completion).toStringAsFixed(1)}h'),
                          ),
                        )
                        .toList()
                        .sizedBoxSpacing(
                          const SizedBox(
                            width: 8,
                          ),
                        ) ??
                    <Widget>[],
              ),
            ),
          ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('Shift details'),
          onTap: () {
            context.goNamed(AppRoute.organizationShift.name, pathParameters: {
              'activityId': shift.activityId.toString(),
              'shiftId': shift.id.toString(),
            });
          },
        ),
        ListTile(
          leading: const Icon(Icons.diversity_1_outlined),
          title: const Text('Activity details'),
          onTap: () {
            context.goNamed(AppRoute.activity.name, pathParameters: {
              'activityId': shift.activityId.toString(),
            });
          },
        ),
        if (volunteer.status == ShiftVolunteerStatus.pending)
          ListTile(
            leading: const Icon(Icons.cancel_outlined),
            title: const Text('Cancel registration'),
            onTap: () async {
              context.pop();
              await showDialog(
                context: context,
                builder: (_) => CancelJoinShiftDialog(
                  activityId: shift.activityId,
                  shiftId: shift.id,
                  shiftName: shift.name,
                ),
              );
            },
          ),
        if (shift.status == ShiftStatus.pending &&
            volunteer.status == ShiftVolunteerStatus.approved)
          ListTile(
            leading: const Icon(Icons.logout_outlined),
            title: const Text('Leave shift'),
            onTap: () async {
              context.pop();
              await showDialog(
                context: context,
                builder: (_) => LeaveShiftDialog(
                  activityId: shift.activityId,
                  shiftId: shift.id,
                  shiftName: shift.name,
                ),
              );
            },
          ),
      ],
    );
  }
}
