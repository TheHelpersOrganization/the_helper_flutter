import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';
import 'package:the_helper/src/utils/location.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;

  const ActivityCard({
    super.key,
    required this.activity,
  });

  @override
  Widget build(BuildContext context) {
    final dateTime = activity.startTime!;
    String slots = activity.joinedParticipants.toString();
    if (activity.maxParticipants != null) {
      slots += '/${activity.maxParticipants}';
      slots += ' Slots';
    } else {
      slots += ' Participants';
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 1,
      child: Row(
        children: [
          SizedBox(
            width: context.mediaQuery.size.width * 0.3,
            child: SvgPicture.asset('assets/images/role_admin.svg'),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.name!,
                    style: context.theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    activity.organization!.name,
                    style: TextStyle(
                      color: context.theme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    getAddress(activity.location),
                  ),
                  const Divider(),
                  Row(
                    children: [
                      const Icon(Icons.access_time),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        '${dateTime.hour}:${dateTime.minute} - ',
                      ),
                      Text(
                        DateFormat('MMM dd, yyyy').format(dateTime),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.supervisor_account),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(slots),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
