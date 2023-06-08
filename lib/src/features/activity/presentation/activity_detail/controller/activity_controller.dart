import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/activity/application/activity_service.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';
import 'package:the_helper/src/features/activity/presentation/activity_detail/screen/activity_detail_screen.dart';
import 'package:the_helper/src/features/profile/domain/profile.dart';

part 'activity_controller.g.dart';

class ExtendedActivity {
  final Activity activity;
  final List<Profile?> managerProfiles;

  ExtendedActivity({
    required this.activity,
    required this.managerProfiles,
  });
}

@riverpod
Future<Activity?> getActivity(GetActivityRef ref, int activityId) {
  return ref.watch(activityServiceProvider).getActivityById(id: activityId);
}

final currentTabProvider = StateProvider<TabType>((ref) => TabType.overview);
