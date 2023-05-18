import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/screens/error_screen.dart';
import 'package:the_helper/src/features/activity/presentation/search/controller/activity_controller.dart';
import 'package:the_helper/src/features/activity/presentation/search/widget/activity_list_placeholder.dart';
import 'package:the_helper/src/features/activity/presentation/search/widget/large_activity_card.dart';

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
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemBuilder: (context, index) =>
              LargeActivityCard(activity: suggestedActivities[index]),
        );
      },
      error: (_, __) => const ErrorScreen(),
      loading: () => SizedBox(
        height: 380,
        child: ActivityListPlaceholder(
          itemCount: 2,
          itemWidth: context.mediaQuery.size.width * 0.7,
          itemHeight: 380,
        ),
      ),
    );
  }
}
