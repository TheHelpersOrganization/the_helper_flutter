import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/screens/error_screen.dart';
import 'package:the_helper/src/features/activity/presentation/search/controller/activity_controller.dart';
import 'package:the_helper/src/features/activity/presentation/search/widget/suggested_activity_card.dart';

class ActivitySuggestionList extends ConsumerStatefulWidget {
  const ActivitySuggestionList({super.key});

  @override
  ConsumerState<ActivitySuggestionList> createState() =>
      _ActivitySuggestionListState();
}

class _ActivitySuggestionListState extends ConsumerState<ActivitySuggestionList>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final suggestedActivities = ref.watch(suggestedActivitiesProvider);

    return suggestedActivities.when(
      data: (suggestedActivities) {
        return ListView(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          children: suggestedActivities
              .map((e) => SuggestedActivityCard(activity: e))
              .toList(),
        );
      },
      error: (_, __) => const ErrorScreen(),
      loading: () => const SizedBox(
        height: 360,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
