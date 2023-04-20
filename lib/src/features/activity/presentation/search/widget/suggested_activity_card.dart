import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';
import 'package:the_helper/src/features/activity/presentation/search/widget/activity_card/activity_card_footer.dart';
import 'package:the_helper/src/features/activity/presentation/search/widget/datetime_card.dart';
import 'package:the_helper/src/utils/location.dart';

class SuggestedActivityCard extends ConsumerWidget {
  final Activity activity;

  const SuggestedActivityCard({
    super.key,
    required this.activity,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: context.mediaQuery.size.width * 0.7,
      height: 500,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: 150,
                    child: SvgPicture.asset(
                      'assets/images/role_admin.svg',
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
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  activity.name!,
                  style: context.theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
