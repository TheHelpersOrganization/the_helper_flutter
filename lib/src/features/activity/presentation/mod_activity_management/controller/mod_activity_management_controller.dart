import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/activity/application/activity_service.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';
import 'package:the_helper/src/features/shift/data/mod_shift_repository.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';
import 'package:the_helper/src/features/shift/domain/shift_query.dart';

enum TabType {
  overview,
  shift,
}

class ActivityAndShifts {
  final Activity activity;
  final List<Shift> shifts;

  ActivityAndShifts({
    required this.activity,
    required this.shifts,
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
    FutureProvider.autoDispose.family<ActivityAndShifts?, int>(
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
    return ActivityAndShifts(activity: activity, shifts: shifts);
  },
);
