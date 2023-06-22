import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/extension/date_time.dart';
import 'package:the_helper/src/common/extension/image.dart';
import 'package:the_helper/src/common/widget/label.dart';
import 'package:the_helper/src/features/profile/domain/profile.dart';
import 'package:the_helper/src/features/shift/domain/shift_volunteer.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift_volunteer/shift_volunteer_applicant_tab.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift_volunteer/shift_volunteer_controller.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift_volunteer/shift_volunteer_participant_tab.dart';
import 'package:the_helper/src/router/router.dart';
import 'package:the_helper/src/utils/image.dart';
import 'package:the_helper/src/utils/profile.dart';

class VolunteerBottomSheet extends ConsumerWidget {
  final String tab;
  final ShiftVolunteer volunteer;
  const VolunteerBottomSheet({
    required this.volunteer,
    required this.tab,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = volunteer.profile!;
    String? subtitle;
    switch (volunteer.status) {
      case ShiftVolunteerStatus.approved:
        subtitle =
            'Approved at ${volunteer.updatedAt.formatDayMonthYearBulletHourSecond()}';
        break;
      case ShiftVolunteerStatus.pending:
        subtitle =
            'Applied at ${volunteer.updatedAt.formatDayMonthYearBulletHourSecond()}';
        break;
      case ShiftVolunteerStatus.leaved:
        subtitle =
            'Leaved at ${volunteer.updatedAt.formatDayMonthYearBulletHourSecond()}';
        break;
      case ShiftVolunteerStatus.rejected:
      case ShiftVolunteerStatus.removed:
        subtitle =
            'Rejected at ${volunteer.updatedAt.formatDayMonthYearBulletHourSecond()}';
        break;
      default:
        subtitle = null;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
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
            // backgroundImage: ImageX.backend(
            //   profile.avatarId!,
            //   loadingBuilder: (context, child, loadingProgress) =>
            //       loadingProgress == null
            //           ? child
            //           : const CircularProgressIndicator(),
            // ).image,
            backgroundImage: getBackendImageOrLogoProvider(
              profile.avatarId,
            ),
            backgroundColor: Theme.of(context).colorScheme.background,
          ),
          subtitle: (subtitle != null) ? Text(subtitle) : null,
        ),
        Divider(),
        ListTile(
          leading: const Icon(Icons.account_circle_outlined),
          title: const Text('View Profile'),
          onTap: () {
            context.goNamed(
              AppRoute.otherProfile.name,
              pathParameters: {
                'userId': profile.id.toString(),
              },
            );
          },
        ),
        if (volunteer.status == ShiftVolunteerStatus.rejected ||
            volunteer.status == ShiftVolunteerStatus.removed ||
            volunteer.status == ShiftVolunteerStatus.pending)
          ListTile(
            leading: const Icon(Icons.check_circle_outline),
            title: const Text('Approve this volunteer'),
            onTap: () {
              ref
                  .read(approveVolunteerControllerProvider(
                          shiftId: volunteer.shiftId, volunteerId: volunteer.id)
                      .notifier)
                  .approveVolunteer();
            },
          ),
        if (tab == ShiftVolunteerParticipantTab.tabName)
          ListTile(
            leading: const Icon(Icons.close_outlined),
            title: const Text('Remove this volunteer'),
            onTap: () {},
          ),
        if (tab == ShiftVolunteerApplicantTab.tabName)
          ListTile(
            leading: const Icon(Icons.close_outlined),
            title: const Text('Reject this volunteer'),
            onTap: () {},
          ),
      ],
    );
  }
}
