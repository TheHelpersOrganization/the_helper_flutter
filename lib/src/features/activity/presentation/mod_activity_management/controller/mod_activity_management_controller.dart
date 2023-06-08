import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/activity/application/activity_service.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';
import 'package:the_helper/src/features/profile/data/profile_repository.dart';
import 'package:the_helper/src/features/profile/domain/get_profiles_data.dart';
import 'package:the_helper/src/features/profile/domain/profile.dart';
import 'package:the_helper/src/features/shift/data/mod_shift_repository.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';
import 'package:the_helper/src/features/shift/domain/shift_query.dart';

enum TabType {
  overview,
  shift,
}

class ExtendedActivity {
  final Activity activity;
  final List<Shift> shifts;
  final List<Profile> managerProfiles;

  ExtendedActivity({
    required this.activity,
    required this.shifts,
    required this.managerProfiles,
  });
}

final currentTabProvider = StateProvider<TabType>((ref) => TabType.overview);

final getActivityProvider = FutureProvider.autoDispose.family<Activity?, int>(
  (ref, activityId) async {
    return ref.watch(activityServiceProvider).getActivityById(id: activityId);
  },
);

final getShiftsByActivityProvider =
    FutureProvider.autoDispose.family<List<Shift>, int>(
  (ref, activityId) => ref
      .watch(modShiftRepositoryProvider)
      .getShifts(query: ShiftQuery(activityId: activityId)),
);

final getActivityAndShiftsProvider =
    FutureProvider.autoDispose.family<ExtendedActivity?, int>(
  (ref, activityId) async {
    final activity = await ref
        .watch(activityServiceProvider)
        .getActivityById(id: activityId);
    if (activity == null) {
      return null;
    }
    final shifts = await ref.watch(modShiftRepositoryProvider).getShifts(
          query: ShiftQuery(
            activityId: activityId,
            include: [
              ShiftQueryInclude.shiftSkill,
            ],
          ),
        );

    final managerProfiles =
        await ref.watch(profileRepositoryProvider).getProfiles(
              GetProfilesData(
                ids: activity.activityManagerIds?.toList(),
              ),
            );

    return ExtendedActivity(
      activity: activity,
      shifts: shifts,
      managerProfiles: managerProfiles,
    );
  },
);
