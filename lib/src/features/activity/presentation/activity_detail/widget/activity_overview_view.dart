import 'package:flutter/material.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';
import 'package:the_helper/src/features/activity/presentation/activity_detail/widget/activity_contact.dart';
import 'package:the_helper/src/features/activity/presentation/activity_detail/widget/activity_date_location.dart';
import 'package:the_helper/src/features/activity/presentation/activity_detail/widget/activity_description.dart';
import 'package:the_helper/src/features/activity/presentation/activity_detail/widget/activity_participant.dart';
import 'package:the_helper/src/features/activity/presentation/activity_detail/widget/activity_skill.dart';

class ActivityOverviewView extends StatelessWidget {
  final Activity activity;
  final bool hasShift;

  const ActivityOverviewView({
    super.key,
    required this.activity,
    this.hasShift = true,
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
        if (hasShift)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ActivityParticipant(activity: activity),
              const SizedBox(
                height: 12,
              ),
              ActivityDateLocation(activity: activity),
              const SizedBox(
                height: 48,
              ),
              ActivitySkill(activity: activity),
              const SizedBox(
                height: 48,
              ),
            ],
          ),
        ActivityContact(activity: activity),
        const SizedBox(
          height: 72,
        ),
      ],
    );
  }
}
