import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/extension/date_time.dart';
import 'package:the_helper/src/common/widget/dialog/confirmation_dialog.dart';
import 'package:the_helper/src/common/widget/label.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';
import 'package:the_helper/src/features/shift/domain/shift_volunteer.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift_volunteer/controller/shift_volunteer_controller.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift_volunteer/widget/review_dialog.dart';
import 'package:the_helper/src/router/router.dart';
import 'package:the_helper/src/utils/image.dart';
import 'package:the_helper/src/utils/profile.dart';

class VolunteerBottomSheet extends ConsumerWidget {
  // final String tab;
  final ShiftVolunteer volunteer;
  // final bool isCompletedShift;
  final ShiftStatus shiftStatus;
  const VolunteerBottomSheet({
    required this.volunteer,
    // required this.tab,
    // required this.isCompletedShift,
    required this.shiftStatus,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = volunteer.profile!;
    String? subtitle;
    switch (volunteer.status) {
      case ShiftVolunteerStatus.approved:
        subtitle =
            'Approved at ${volunteer.updatedAt.formatDayMonthYearBulletHourMinute()}';
        break;
      case ShiftVolunteerStatus.pending:
        subtitle =
            'Applied at ${volunteer.updatedAt.formatDayMonthYearBulletHourMinute()}';
        break;
      case ShiftVolunteerStatus.left:
        subtitle =
            'Left at ${volunteer.updatedAt.formatDayMonthYearBulletHourMinute()}';
        break;
      case ShiftVolunteerStatus.rejected:
      case ShiftVolunteerStatus.removed:
        subtitle =
            'Rejected at ${volunteer.updatedAt.formatDayMonthYearBulletHourMinute()}';
        break;
      default:
        subtitle = null;
    }
    final isReviewed = volunteer.completion != 0 ||
        (volunteer.reviewNote != null && volunteer.reviewNote!.isNotEmpty);
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              onTap: () {
                context.pushNamed(
                  AppRoute.otherProfile.name,
                  pathParameters: {
                    'userId': profile.id.toString(),
                  },
                );
              },
              contentPadding: const EdgeInsets.all(0),
              title: Text.rich(
                TextSpan(
                  text: getProfileName(profile),
                  children: [
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Label(
                          labelText: volunteer.status.name.toUpperCase(),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              leading: CircleAvatar(
                radius: 24,
                backgroundImage: getBackendImageOrLogoProvider(
                  profile.avatarId,
                ),
                backgroundColor: Theme.of(context).colorScheme.background,
              ),
              subtitle: (subtitle != null) ? Text(subtitle) : null,
            ),
          ),
          if (shiftStatus == ShiftStatus.pending &&
              (volunteer.meetSkillRequirements == false ||
                  volunteer.hasTravelingConstrainedShift == true))
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.warning,
                        color: Colors.deepOrange,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Expanded(
                        child: Text(
                          'Volunteer may not be suitable for this shift',
                          style: TextStyle(color: Colors.deepOrange),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  if (volunteer.meetSkillRequirements == false)
                    const Text(
                      '- Volunteer does not meet skill requirements',
                      style: TextStyle(color: Colors.deepOrange),
                    ),
                  if (volunteer.hasTravelingConstrainedShift == true)
                    const Text(
                      '- Volunteer has registered for another shift that may not have enough time to travel to this shift',
                      style: TextStyle(color: Colors.deepOrange),
                    ),
                ],
              ),
            ),
          if (shiftStatus == ShiftStatus.ongoing ||
              shiftStatus == ShiftStatus.completed) ...[
            // if (volunteer.checkedIn ?? false)
            ListTile(
              onTap: () {
                context.pop();
                ref
                    .read(changeVolunteerStatusControllerProvider.notifier)
                    .toggleVerifyAttendance(volunteer, checkIn: true);

                ref.invalidate(selectedVolunteerProvider);
              },
              leading: volunteer.isCheckInVerified ?? false
                  ? const Icon(Icons.verified)
                  : const Icon(Icons.verified_outlined),
              title: volunteer.isCheckInVerified ?? false
                  ? const Text(
                      'Verified check-in',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  : const Text(
                      'Unverified check-in',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
              subtitle: volunteer.checkedIn ?? false
                  ? Row(
                      children: [
                        const Text(
                          'Checked in at',
                        ),
                        Text(
                          volunteer.checkInAt!
                              .formatDayMonthYearBulletHourMinute(),
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ],
                    )
                  : const Text(
                      'Not checked in yet!',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
            ),

            ListTile(
              onTap: () {
                context.pop();
                ref
                    .read(changeVolunteerStatusControllerProvider.notifier)
                    .toggleVerifyAttendance(volunteer, checkIn: false);

                ref.invalidate(selectedVolunteerProvider);
              },
              leading: volunteer.isCheckOutVerified ?? false
                  ? const Icon(Icons.verified)
                  : const Icon(Icons.verified_outlined),
              title: volunteer.isCheckOutVerified ?? false
                  ? const Text(
                      'Verified check-out',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  : const Text(
                      'Unverified check-out',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
              subtitle: volunteer.checkedOut ?? false
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Checked out at',
                        ),
                        Text(
                          volunteer.checkOutAt!
                              .formatDayMonthYearBulletHourMinute(),
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ],
                    )
                  : const Text(
                      'Not checked out yet!',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
            ),
          ],
          if (shiftStatus == ShiftStatus.completed && isReviewed) ...[
            ListTile(
              onTap: () {
                ref.read(sliderValueProvider.notifier).state =
                    volunteer.completion;
                ref.read(textValueProvider.notifier).state =
                    volunteer.reviewNote ?? '';
                context.pop();
                showDialog(
                  context: context,
                  builder: (context) {
                    return ReviewDialog(
                      volunteer: volunteer,
                    );
                  },
                );
              },
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Completion',
                    style: context.theme.textTheme.bodyLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${volunteer.completion.toInt().toString()}%',
                    style: context.theme.textTheme.bodyLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            ListTile(
              onTap: () {
                ref.read(sliderValueProvider.notifier).state =
                    volunteer.completion;
                ref.read(textValueProvider.notifier).state =
                    volunteer.reviewNote ?? '';
                context.pop();
                showDialog(
                  context: context,
                  builder: (context) {
                    return ReviewDialog(
                      volunteer: volunteer,
                    );
                  },
                );
              },
              title: Text(
                'Review Note',
                style: context.theme.textTheme.bodyLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              onTap: () {
                ref.read(sliderValueProvider.notifier).state =
                    volunteer.completion;
                ref.read(textValueProvider.notifier).state =
                    volunteer.reviewNote ?? '';
                context.pop();
                showDialog(
                  context: context,
                  builder: (context) {
                    return ReviewDialog(
                      volunteer: volunteer,
                    );
                  },
                );
              },
              leading: const Icon(Icons.comment_outlined),
              title: (volunteer.reviewNote == null ||
                      volunteer.reviewNote!.isEmpty)
                  ? const Text(
                      "Didn't reviewed yet!",
                      style: TextStyle(fontStyle: FontStyle.italic),
                    )
                  : Text(
                      volunteer.reviewNote!,
                      style: context.theme.textTheme.bodyMedium,
                    ),
            ),
          ],
          // if (isCompletedShift &&
          //     volunteer.status == ShiftVolunteerStatus.approved)
          if (shiftStatus == ShiftStatus.completed &&
              volunteer.status == ShiftVolunteerStatus.approved &&
              !isReviewed)
            ListTile(
              leading: const Icon(Icons.reviews),
              title: isReviewed
                  ? const Text('Review this volunteer again')
                  : const Text('Review this volunteer'),
              onTap: () {
                ref.read(sliderValueProvider.notifier).state =
                    volunteer.completion;
                ref.read(textValueProvider.notifier).state =
                    volunteer.reviewNote ?? '';
                context.pop();
                showDialog(
                  context: context,
                  builder: (context) {
                    return ReviewDialog(
                      volunteer: volunteer,
                    );
                  },
                );
                // context.goNamed(
                //   AppRoute.shiftVolunteerReview.name,
                //   pathParameters: {
                //     'volunteerId': volunteer.id.toString(),
                //     'activityId': volunteer.shift!.activityId.toString(),
                //   },
                // );
              },
            ),
          if (volunteer.status == ShiftVolunteerStatus.rejected ||
              volunteer.status == ShiftVolunteerStatus.removed ||
              volunteer.status == ShiftVolunteerStatus.pending)
            ListTile(
              leading: const Icon(Icons.check_outlined),
              title: const Text('Approve this volunteer'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => Consumer(
                    builder: (context, ref, _) => ConfirmationDialog(
                      titleText: "Approve this volunteer",
                      contentColumnChildren: [
                        const Text("Do you want to approve this volunteer?"),
                        if (volunteer.meetSkillRequirements == false ||
                            volunteer.hasTravelingConstrainedShift == true)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Row(
                                  children: [
                                    Icon(
                                      Icons.warning,
                                      color: Colors.deepOrange,
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Expanded(
                                      child: Text(
                                        'Volunteer may not be suitable for this shift',
                                        style:
                                            TextStyle(color: Colors.deepOrange),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                if (volunteer.meetSkillRequirements == false)
                                  const Text(
                                    '- Volunteer does not meet skill requirements',
                                    style: TextStyle(color: Colors.deepOrange),
                                  ),
                                if (volunteer.hasTravelingConstrainedShift ==
                                    true)
                                  const Text(
                                    '- Volunteer has registered for another shift that may not have enough time to travel to this shift',
                                    style: TextStyle(color: Colors.deepOrange),
                                  ),
                              ],
                            ),
                          ),
                      ],
                      onConfirm: () {
                        context.pop();
                        ref
                            .read(changeVolunteerStatusControllerProvider
                                .notifier)
                            .approveVolunteer(volunteer);
                      },
                    ),
                  ),
                );

                context.navigator.pop();
              },
            ),
          // if (volunteer.status == ShiftVolunteerStatus.approved &&
          //     !isCompletedShift)
          if (volunteer.status == ShiftVolunteerStatus.approved &&
              !(shiftStatus == ShiftStatus.completed))
            ListTile(
              leading: const Icon(Icons.close_outlined),
              title: const Text('Remove this volunteer'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => Consumer(
                    builder: (context, ref, _) => ConfirmationDialog(
                      titleText: "Remove this volunteer",
                      content:
                          const Text("Do you want to remove this volunteer?"),
                      onConfirm: () {
                        context.pop();
                        ref
                            .read(changeVolunteerStatusControllerProvider
                                .notifier)
                            .removeVolunteer(volunteer);
                      },
                    ),
                  ),
                );
                context.navigator.pop();
              },
            ),
          if (volunteer.status == ShiftVolunteerStatus.pending)
            ListTile(
              leading: const Icon(Icons.close_outlined),
              title: const Text('Reject this volunteer'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => Consumer(
                    builder: (context, ref, _) => ConfirmationDialog(
                      titleText: "Reject this volunteer",
                      content:
                          const Text("Do you want to reject this volunteer?"),
                      onConfirm: () {
                        context.pop();
                        ref
                            .read(changeVolunteerStatusControllerProvider
                                .notifier)
                            .rejectVolunteer(volunteer);
                      },
                    ),
                  ),
                );
                context.navigator.pop();
              },
            ),
        ],
      ),
    );
  }
}
