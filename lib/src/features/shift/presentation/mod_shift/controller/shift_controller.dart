import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/activity/application/activity_service.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';
import 'package:the_helper/src/features/profile/data/profile_repository.dart';
import 'package:the_helper/src/features/profile/domain/get_profiles_data.dart';
import 'package:the_helper/src/features/shift/data/mod_shift_repository.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';
import 'package:the_helper/src/features/shift/domain/shift_query.dart';

class ActivityAndShift {
  final Activity activity;
  final Shift shift;

  ActivityAndShift({
    required this.activity,
    required this.shift,
  });
}

final getActivityAndShiftProvider =
    FutureProvider.autoDispose.family<ActivityAndShift?, int>(
  (ref, shiftId) async {
    final shift = await ref.watch(modShiftRepositoryProvider).getShiftById(
          id: shiftId,
          query: const ShiftQuery(
            include: [
              ShiftQueryInclude.shiftSkill,
              ShiftQueryInclude.shiftManager,
            ],
          ),
        );
    if (shift == null) {
      return null;
    }
    final activity = await ref
        .watch(activityServiceProvider)
        .getActivityById(id: shift.activityId);
    final managerProfiles =
        await ref.watch(profileRepositoryProvider).getProfiles(
              GetProfilesData(
                ids: shift.shiftManagers!.map((e) => e.accountId).toList(),
              ),
            );
    final updatedShift = shift.copyWith(
      shiftManagers: shift.shiftManagers!.map((e) {
        final profile = managerProfiles.firstWhereOrNull(
          (element) => element.id == e.accountId,
        );
        return e.copyWith(profile: profile);
      }).toList(),
    );

    return ActivityAndShift(
      activity: activity!,
      shift: updatedShift,
    );
  },
);
