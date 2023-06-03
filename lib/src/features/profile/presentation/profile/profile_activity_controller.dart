import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/activity/data/activity_repository.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';

part 'profile_activity_controller.g.dart';

@riverpod
class ProfileActivityController extends _$ProfileActivityController {
  @override
  FutureOr<List<Activity>> build() async {
    return _getJoinedAndCompletedActivity();
  }

  Future<List<Activity>> _getJoinedAndCompletedActivity() async {
    final ActivityRepository activityRepository =
        ref.watch(activityRepositoryProvider);
    final List<Activity> activities =
        await activityRepository.getActivitiesQ(queryParameters: {
      'status': 'completed',
      'joinStatus': 'approved',
    });
    // print(activities);
    return activities;
  }
}
