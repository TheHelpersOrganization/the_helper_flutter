import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/activity/application/activity_service.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';

part 'activity_controller.g.dart';

@riverpod
Future<Activity?> getActivity(GetActivityRef ref, int activityId) {
  return ref.watch(activityServiceProvider).getActivityById(id: activityId);
}
