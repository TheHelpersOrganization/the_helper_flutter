import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/change_role/presentation/widgets/volunteer_analytics_main_card.dart';
import 'package:the_helper/src/features/change_role/presentation/widgets/volunteer_analytics_secondary_card.dart';

class VolunteerAnalytics extends ConsumerWidget {
  const VolunteerAnalytics({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Flexible(
          flex: 3,
          child: VolunteerAnalyticsMainCard(),
        ),
        Flexible(
          flex: 2,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              VolunteerAnalyticsSecondaryCard(
                titleText: '30',
                metaText: '+3h',
                subtitleText: 'Activities Participated',
                margin: EdgeInsets.only(left: 2, bottom: 2),
              ),
              VolunteerAnalyticsSecondaryCard(
                titleText: '120',
                metaText: '+240h',
                subtitleText: 'Hours contributed',
                margin: EdgeInsets.only(left: 2, top: 2),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
