import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/activity/application/activity_service.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';
import 'package:the_helper/src/features/activity/my_activity/controller/my_activity_controller.dart';
import 'package:the_helper/src/features/activity/presentation/activity_detail/screen/activity_detail_screen.dart';
import 'package:the_helper/src/features/profile/data/profile_repository.dart';
import 'package:the_helper/src/features/profile/domain/get_profiles_data.dart';
import 'package:the_helper/src/features/profile/domain/profile.dart';
import 'package:the_helper/src/features/shift/data/shift_repository.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';
import 'package:the_helper/src/features/shift/domain/shift_query.dart';
import 'package:the_helper/src/features/shift/domain/shift_volunteer.dart';
import 'package:the_helper/src/features/shift/domain/shift_volunteer_query.dart';
import 'package:the_helper/src/features/shift/presentation/shift/controller/shift_controller.dart';
import 'package:the_helper/src/utils/async_value.dart';

class ExtendedActivity {
  final Activity activity;
  final List<Shift> shifts;
  final List<Profile> managerProfiles;
  final List<ShiftVolunteer> myShiftVolunteers;

  ExtendedActivity({
    required this.activity,
    required this.shifts,
    required this.managerProfiles,
    required this.myShiftVolunteers,
  });
}

final currentTabProvider = StateProvider<TabType>((ref) => TabType.overview);

final getActivityProvider = FutureProvider.autoDispose.family<Activity?, int>(
  (ref, activityId) async {
    return ref.watch(activityServiceProvider).getActivityById(id: activityId);
  },
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
    print('activityy');
    final shifts = ref.watch(shiftRepositoryProvider).getShifts(
          query: ShiftQuery(
            activityId: activityId,
            include: [
              ShiftQueryInclude.shiftSkill,
            ],
          ),
        );
    print('shifts');
    final managerProfiles = ref.watch(profileRepositoryProvider).getProfiles(
          GetProfilesData(
            ids: activity.activityManagerIds?.toList(),
          ),
        );

    final myShiftVolunteers =
        ref.watch(shiftRepositoryProvider).getShiftVolunteers(
              query: ShiftVolunteerQuery(
                activityId: activityId,
                mine: true,
              ),
            );

    return ExtendedActivity(
      activity: activity,
      shifts: await shifts,
      managerProfiles: await managerProfiles,
      myShiftVolunteers: await myShiftVolunteers,
    );
  },
);

class JoinShiftController extends StateNotifier<AsyncValue<void>> {
  final AutoDisposeStateNotifierProviderRef ref;
  final ShiftRepository shiftRepository;

  JoinShiftController({
    required this.ref,
    required this.shiftRepository,
  }) : super(const AsyncValue.data(null));

  Future<void> joinShift({
    required int shiftId,
  }) async {
    if (state.isLoading) {
      return;
    }
    state = const AsyncValue.loading();
    final res = await guardAsyncValue(
      () => shiftRepository.joinShift(
        shiftId: shiftId,
      ),
    );
    if (!res.hasError) {
      ref.invalidate(getActivityAndShiftsProvider);
      ref.invalidate(getActivityAndShiftProvider);
    }
    if (!mounted) {
      return;
    }
    state = res;
  }
}

class CancelJoinShiftController extends StateNotifier<AsyncValue<void>> {
  final AutoDisposeStateNotifierProviderRef ref;
  final ShiftRepository shiftRepository;

  CancelJoinShiftController({
    required this.ref,
    required this.shiftRepository,
  }) : super(const AsyncValue.data(null));

  Future<void> cancelJoinShift({
    required int shiftId,
  }) async {
    if (state.isLoading) {
      return;
    }
    state = const AsyncValue.loading();
    final res = await guardAsyncValue(
      () => shiftRepository.cancelJoinShift(
        shiftId: shiftId,
      ),
    );
    if (!res.hasError) {
      ref.invalidate(getActivityAndShiftsProvider);
      ref.invalidate(getActivityAndShiftProvider);
      ref.invalidate(myActivityPagingControllerProvider);
    }
    if (!mounted) {
      return;
    }
    state = res;
  }
}

class LeaveShiftController extends StateNotifier<AsyncValue<void>> {
  final AutoDisposeStateNotifierProviderRef ref;
  final ShiftRepository shiftRepository;

  LeaveShiftController({
    required this.ref,
    required this.shiftRepository,
  }) : super(const AsyncValue.data(null));

  Future<void> leaveShift({
    required int shiftId,
  }) async {
    if (state.isLoading) {
      return;
    }
    state = const AsyncValue.loading();
    final res = await guardAsyncValue(
      () => shiftRepository.leaveShift(
        shiftId: shiftId,
      ),
    );
    if (!res.hasError) {
      ref.invalidate(getActivityAndShiftsProvider);
      ref.invalidate(getActivityAndShiftProvider);
      ref.invalidate(myActivityPagingControllerProvider);
    }
    if (!mounted) {
      return;
    }
    state = res;
  }
}

final joinShiftControllerProvider =
    StateNotifierProvider.autoDispose<JoinShiftController, AsyncValue<void>>(
  (ref) => JoinShiftController(
    ref: ref,
    shiftRepository: ref.watch(shiftRepositoryProvider),
  ),
);

final cancelJoinShiftControllerProvider = StateNotifierProvider.autoDispose<
    CancelJoinShiftController, AsyncValue<void>>(
  (ref) => CancelJoinShiftController(
    ref: ref,
    shiftRepository: ref.watch(shiftRepositoryProvider),
  ),
);

final leaveShiftControllerProvider =
    StateNotifierProvider.autoDispose<LeaveShiftController, AsyncValue<void>>(
  (ref) => LeaveShiftController(
    ref: ref,
    shiftRepository: ref.watch(shiftRepositoryProvider),
  ),
);
