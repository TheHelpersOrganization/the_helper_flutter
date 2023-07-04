import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';
import 'package:the_helper/src/features/activity/presentation/search/widget/activity_card/activity_card_footer.dart';
import 'package:the_helper/src/features/activity/presentation/search/widget/datetime_card.dart';
import 'package:the_helper/src/router/router.dart';
import 'package:the_helper/src/utils/domain_provider.dart';
import 'package:the_helper/src/utils/location.dart';

class LargeActivityCard extends ConsumerWidget {
  final Activity activity;
  final double? width;
  final double? height;

  const LargeActivityCard({
    super.key,
    required this.activity,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: width ?? context.mediaQuery.size.width * 0.7,
      height: height ?? 380,
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: () {
            context.goNamed(AppRoute.activity.name, pathParameters: {
              'activityId': activity.id.toString(),
            });
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: 150,
                    child: activity.thumbnail != null
                        ? CachedNetworkImage(
                            imageUrl: getImageUrl(activity.thumbnail!),
                            width: context.mediaQuery.size.width * 0.7,
                            fit: BoxFit.cover,
                          )
                        : SvgPicture.asset(
                            'assets/images/role_volunteer.svg',
                            width: context.mediaQuery.size.width * 0.7,
                            fit: BoxFit.cover,
                          ),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: DateTimeCard(dateTime: activity.startTime!),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        activity.name!,
                        style: context.theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      activity.organization!.name,
                      style: TextStyle(
                        color: context.theme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(
                        getAddress(activity.location),
                        style: context.theme.textTheme.bodyMedium,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12, bottom: 12),
                      child: Text(
                        activity.description!,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    ActivityCardFooter(
                      joinedParticipants: activity.joinedParticipants!,
                      maxParticipants: activity.maxParticipants,
                      avatarIds: activity.volunteers!
                          .map((e) => e.profile!.avatarId)
                          .toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
