import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/widget/error_widget.dart';
import 'package:the_helper/src/features/activity/presentation/search/controller/activity_controller.dart';
import 'package:the_helper/src/features/activity/presentation/search/widget/activity_card/activity_card.dart';

class SuggestedActivityScreen extends ConsumerWidget {
  const SuggestedActivityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suggestedActivitiesState = ref.watch(suggestedActivitiesProvider(20));

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          const SliverAppBar(
            title: Text('Suggested activities'),
            floating: true,
          ),
        ],
        body: suggestedActivitiesState.when(
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stackTrace) => Center(
            child: CustomErrorWidget(
              onRetry: () => ref.invalidate(suggestedActivitiesProvider),
            ),
          ),
          data: (suggestedActivities) => Padding(
            padding: const EdgeInsets.all(12),
            child: ListView.builder(
              itemBuilder: (context, index) => ActivityCard(
                activity: suggestedActivities[index],
              ),
              itemCount: suggestedActivities.length,
            ),
          ),
        ),
      ),
    );
  }
}
