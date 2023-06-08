import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/activity/data/activity_repository.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';

part 'profile_activity_controller.g.dart';

// @riverpod
// class ProfileActivityController extends _$ProfileActivityController {
//   @override
//   FutureOr<List<Activity>> build() async {
//     return getJoinedAndCompletedActivity();
//   }

//   Future<List<Activity>> getJoinedAndCompletedActivity({
//     int page = 0,
//     int limit = 10,
//   }) async {
//     final ActivityRepository activityRepository =
//         ref.watch(activityRepositoryProvider);
//     final List<Activity> activities =
//         await activityRepository.getActivitiesQ(queryParameters: {
//       'status': 'completed',
//       'joinStatus': 'approved',
//       'limit': limit,
//       'offset': page * limit,
//     });
//     // print(activities);
//     return activities;
//   }
// }

@riverpod
Future<List<Activity>> activityController(
  ActivityControllerRef ref, [
  int page = 0,
  int size = 10,
]) async {
  final keepAliveLink = ref.keepAlive();
  Timer(Duration(minutes: 5), () {
    keepAliveLink.close();
  });
  final ActivityRepository activityRepository =
      ref.watch(activityRepositoryProvider);
  final List<Activity> activities =
      await activityRepository.getActivitiesQ(queryParameters: {
    'status': 'completed',
    'joinStatus': 'approved',
    'limit': size,
    'offset': page * size,
  });
  return activities;
}
