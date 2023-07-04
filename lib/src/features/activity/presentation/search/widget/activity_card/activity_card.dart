import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
  final double? height;
  final VoidCallback? onTap;

  const ActivityCard({
    super.key,
    required this.activity,
    this.height = 190,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dateTime = activity.startTime;
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
        onTap: onTap ??
            () {
              context.goNamed(AppRoute.activity.name, pathParameters: {
                'activityId': activity.id.toString(),
              });
            },
        child: SizedBox(
          height: height,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: context.mediaQuery.size.width * 0.35,
                height: height,
                child: activity.thumbnail != null
                    ? CachedNetworkImage(
                        imageUrl: getImageUrl(activity.thumbnail!),
                        fit: BoxFit.fitHeight,
                        errorWidget: (context, error, stackTrace) =>
                            SvgPicture.asset(
                                'assets/images/role_volunteer.svg'),
                      )
                    : SvgPicture.asset(
                        'assets/images/role_volunteer.svg',
                        fit: BoxFit.fitHeight,
                      ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        activity.name ?? 'Unknown activity',
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
                        activity.organization?.name ?? 'Unknown Organization',
                        style: TextStyle(
                          color: context.theme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      // Wrap it with flexible to detect overflow
                      Flexible(
                        child: AutoSizeText(
                          getAddress(activity.location),
                          style: TextStyle(
                            color: context.theme.colorScheme.secondary,
                          ),
                          maxLines: 1,
                          overflowReplacement: Text(
                            getAddress(
                              activity.location,
                              componentCount: 2,
                            ),
                          ),
                        ),
                      ),
                      const Divider(),
                      Row(
                        children: [
                          const Icon(Icons.access_time),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            dateTime != null
                                ? DateFormat('hh:mm - ').format(dateTime)
                                : 'Unknown',
                          ),
                          Text(
                            dateTime != null
                                ? DateFormat('MMM dd, yyyy').format(dateTime)
                                : '',
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
      ),
    );
  }
}
