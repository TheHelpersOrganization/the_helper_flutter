import 'package:flutter/material.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';

class ActivityParticipant extends StatelessWidget {
  final Activity activity;

  const ActivityParticipant({
    super.key,
    required this.activity,
    bool hasShift = true,
  });

  @override
  Widget build(BuildContext context) {
    String slots = '';
    int joinedParticipants = activity.joinedParticipants ?? 0;
    if (activity.maxParticipants != null) {
      slots += '$joinedParticipants/${activity.maxParticipants}';
    } else {
      slots += '$joinedParticipants Joined';
    }
    final joinedPercentage =
        activity.maxParticipants == null || activity.maxParticipants! < 1
            ? null
            : joinedParticipants / activity.maxParticipants!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Participants',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(slots),
          ],
        ),
        if (joinedPercentage != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: LinearProgressIndicator(
              value: joinedPercentage,
            ),
          ),
        if (activity.maxParticipants != null)
          Text(
            '${activity.maxParticipants! - joinedParticipants} slots remaining',
          )
        else
          const Text('Unlimited slots'),
      ],
    );
  }
}
