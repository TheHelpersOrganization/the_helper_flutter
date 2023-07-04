import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/widget/error_widget.dart';
import 'package:the_helper/src/features/activity/presentation/search/controller/activity_controller.dart';
import 'package:the_helper/src/features/activity/presentation/search/widget/activity_list_placeholder.dart';
import 'package:the_helper/src/features/activity/presentation/search/widget/large_activity_card.dart';

class SliverActivitySuggestionList extends ConsumerWidget {
  const SliverActivitySuggestionList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suggestedActivities = ref.watch(suggestedActivitiesProvider);

    return SliverToBoxAdapter(
      child: SizedBox(
        height: 380,
        child: suggestedActivities.when(
          skipLoadingOnRefresh: false,
          data: (suggestedActivities) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: suggestedActivities.length,
              itemBuilder: (context, index) =>
                  LargeActivityCard(activity: suggestedActivities[index]),
            );
          },
          error: (_, __) => CustomErrorWidget(
            onRetry: () {
              ref.invalidate(suggestedActivitiesProvider);
            },
          ),
          loading: () => SizedBox(
            height: 380,
            child: ActivityListPlaceholder(
              itemCount: 2,
              itemWidth: context.mediaQuery.size.width * 0.7,
              itemHeight: 380,
            ),
          ),
        ),
      ),
    );
  }
}
