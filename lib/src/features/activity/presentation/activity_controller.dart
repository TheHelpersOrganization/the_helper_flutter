import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/activity/application/activity_service.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';
import 'package:the_helper/src/features/activity/domain/activity_query.dart';

part 'activity_controller.g.dart';

@riverpod
Future<List<Activity>> suggestedActivities(SuggestedActivitiesRef ref) async {
  return ref.watch(activityServiceProvider).getSuggestedActivities(
        query: ActivityQuery(limit: 5),
      );
}
