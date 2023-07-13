import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/change_role/presentation/widgets/volunteer_analytics_secondary_card.dart';

class VolunteerAnalytics extends ConsumerWidget {
  final List<String>? skillList;
  final int totalActivity;
  final int increasedActivity;
  final double totalHour;
  final double increasedHour;

  const VolunteerAnalytics({
    super.key,
    this.skillList,
    required this.totalActivity,
    required this.increasedActivity,
    required this.totalHour,
    required this.increasedHour,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        VolunteerAnalyticsSecondaryCard(
          titleText: totalActivity.toString(),
          metaText: '+$increasedActivity h',
          subtitleText: 'Activities Participated',
          margin: const EdgeInsets.only(left: 2, bottom: 2),
        ),
        VolunteerAnalyticsSecondaryCard(
          titleText: totalHour.toString(),
          metaText: '+$increasedHour h',
          subtitleText: 'Hours contributed',
          margin: const EdgeInsets.only(left: 2, top: 2),
        ),
      ],
    );
  }
}
