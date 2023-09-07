import 'package:flutter/material.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';
import 'package:the_helper/src/features/activity/presentation/activity_detail/widget/activity_contact.dart';
import 'package:the_helper/src/features/activity/presentation/activity_detail/widget/activity_date_location.dart';
import 'package:the_helper/src/features/activity/presentation/activity_detail/widget/activity_description.dart';
import 'package:the_helper/src/features/activity/presentation/activity_detail/widget/activity_managers.dart';
import 'package:the_helper/src/features/activity/presentation/activity_detail/widget/activity_participant.dart';
import 'package:the_helper/src/features/activity/presentation/activity_detail/widget/activity_skill.dart';
import 'package:the_helper/src/features/profile/domain/profile.dart';

class ActivityOverviewView extends StatelessWidget {
  final Activity activity;
  final List<Profile>? managerProfiles;

  final bool hasShift;

  const ActivityOverviewView({
    super.key,
    required this.activity,
    this.hasShift = true,
    this.managerProfiles,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ActivityDescription(
          activity: activity,
        ),
        const SizedBox(
          height: 48,
        ),
        if (hasShift) ...[
          ActivityParticipant(activity: activity),
          const SizedBox(
            height: 12,
          ),
        ],
        ActivityDateLocation(activity: activity),
        const SizedBox(
          height: 48,
        ),
        if (hasShift)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ActivitySkill(activity: activity),
              const SizedBox(
                height: 48,
              ),
            ],
          ),
        ActivityContact(activity: activity),
        const SizedBox(
          height: 48,
        ),
        ActivityManagers(
          managers: activity.activityManagerIds,
          profiles: managerProfiles,
        ),
        const SizedBox(
          height: 72,
        ),
      ],
    );
  }
}
