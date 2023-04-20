import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/screens/error_screen.dart';
import 'package:the_helper/src/features/activity/presentation/suggested_activity_card.dart';

import 'activity_controller.dart';

class ActivitySuggestionList extends ConsumerWidget {
  const ActivitySuggestionList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suggestedActivities = ref.watch(suggestedActivitiesProvider);

    return suggestedActivities.when(
      data: (suggestedActivities) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: suggestedActivities
                .map((e) => SuggestedActivityCard(activity: e))
                .toList(),
          ),
        );
      },
      error: (_, __) => const ErrorScreen(),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
