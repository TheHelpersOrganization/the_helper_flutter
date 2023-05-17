import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';
import 'package:the_helper/src/router/router.dart';
import 'package:the_helper/src/utils/domain_provider.dart';
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
      clipBehavior: Clip.antiAlias,
      elevation: 1,
      child: InkWell(
        onTap: () {
          context.goNamed(AppRoute.activity.name, params: {
            'activityId': activity.id.toString(),
          });
        },
        child: Row(
          children: [
            SizedBox(
              width: context.mediaQuery.size.width * 0.3,
              height: 200,
              child: activity.thumbnail != null
                  ? Image.network(
                      getImageUrl(activity.thumbnail!),
                      fit: BoxFit.fitHeight,
                      errorBuilder: (context, error, stackTrace) =>
                          SvgPicture.asset('assets/images/role_volunteer.svg'),
                    )
                  : SvgPicture.asset(
                      'assets/images/role_volunteer.svg',
                      fit: BoxFit.fitHeight,
                    ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${activity.name!}sdfdsfsdfdsfsdffsdf',
                      style: context.theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined),
                        const SizedBox(
                          width: 8,
                        ),
                        // Wrap it with flexible to detect overflow
                        Flexible(
                          child: AutoSizeText(
                            getAddress(activity.location),
                            maxLines: 1,
                            overflowReplacement: Text(getAddress(
                              activity.location,
                              componentCount: 2,
                            )),
                          ),
                        )
                      ],
                    ),
                    const Divider(),
                    Row(
                      children: [
                        const Icon(Icons.access_time),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          DateFormat('hh:mm - ').format(dateTime),
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
      ),
    );
  }
}
