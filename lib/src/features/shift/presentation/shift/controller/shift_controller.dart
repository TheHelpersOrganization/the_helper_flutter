import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/features/activity/application/activity_service.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_management/controller/mod_activity_management_controller.dart';
import 'package:the_helper/src/features/profile/data/profile_repository.dart';
import 'package:the_helper/src/features/profile/domain/get_profiles_data.dart';
import 'package:the_helper/src/features/shift/data/shift_repository.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';
import 'package:the_helper/src/features/shift/domain/shift_query.dart';
import 'package:the_helper/src/features/shift/domain/shift_volunteer.dart';
import 'package:the_helper/src/features/shift/domain/shift_volunteer_query.dart';
import 'package:the_helper/src/router/router.dart';
import 'package:the_helper/src/utils/async_value.dart';

class ActivityAndShift {
  final Activity activity;
  final Shift shift;
  final List<ShiftVolunteer> myShiftVolunteers;
  final ShiftVolunteer? latestShiftVolunteer;

  ActivityAndShift({
    required this.activity,
    required this.shift,
    required this.myShiftVolunteers,
    required this.latestShiftVolunteer,
  });
}

final getActivityAndShiftProvider =
    FutureProvider.autoDispose.family<ActivityAndShift?, int>(
  (ref, shiftId) async {
    final shift = await ref.watch(shiftRepositoryProvider).getShiftById(
          id: shiftId,
          query: const ShiftQuery(
            include: [
              ShiftQueryInclude.shiftSkill,
              ShiftQueryInclude.shiftManager,
              ShiftQueryInclude.myShiftVolunteer,
              ShiftQueryInclude.shiftOverlaps,
              ShiftQueryInclude.travelingConstrainedShifts,
            ],
          ),
        );
    final activity = await ref
        .watch(activityServiceProvider)
        .getActivityById(id: shift.activityId);
    final managerProfiles =
        await ref.watch(profileRepositoryProvider).getProfiles(
              GetProfilesData(
                ids: shift.shiftManagers!.map((e) => e.accountId).toList(),
              ),
            );
    final myShiftVolunteers =
        await ref.watch(shiftRepositoryProvider).getShiftVolunteers(
              query: ShiftVolunteerQuery(
                shiftId: shift.id,
                mine: true,
              ),
            );
    var latestShiftVolunteer = myShiftVolunteers.firstOrNull;
    for (final volunteer in myShiftVolunteers) {
      if (volunteer.updatedAt.isAfter(latestShiftVolunteer!.updatedAt)) {
        latestShiftVolunteer = volunteer;
      }
    }
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
      myShiftVolunteers: myShiftVolunteers,
      latestShiftVolunteer: latestShiftVolunteer,
    );
  },
);

class DeleteShiftController extends StateNotifier<AsyncValue<void>> {
  final AutoDisposeStateNotifierProviderRef ref;
  final ShiftRepository modShiftRepository;
  final GoRouter router;

  DeleteShiftController({
    required this.ref,
    required this.modShiftRepository,
    required this.router,
  }) : super(const AsyncValue.data(null));

  Future<void> deleteShift({
    required int activityId,
    required int shiftId,
    bool navigateToActivityManagement = true,
  }) async {
    state = const AsyncValue.loading();
    final res = await guardAsyncValue(
        () => modShiftRepository.deleteShift(id: shiftId));

    if (!res.hasError) {
      ref.invalidate(getActivityAndShiftsProvider);
    }

    if (!mounted) {
      return;
    }

    state = res;

    if (navigateToActivityManagement) {
      router.goNamed(
        AppRoute.organizationActivityManagement.name,
        pathParameters: {'activityId': activityId.toString()},
      );
    }
  }
}

final deleteShiftControllerProvider =
    StateNotifierProvider.autoDispose<DeleteShiftController, AsyncValue<void>>(
  (ref) => DeleteShiftController(
    ref: ref,
    modShiftRepository: ref.watch(shiftRepositoryProvider),
    router: ref.watch(routerProvider),
  ),
);

class CheckInController extends StateNotifier<AsyncValue<void>> {
  final AutoDisposeStateNotifierProviderRef ref;
  final ShiftRepository shiftRepository;

  CheckInController({
    required this.ref,
    required this.shiftRepository,
  }) : super(const AsyncValue.data(null));

  Future<void> checkIn({required int shiftId}) async {
    if (state.isLoading) {
      return;
    }
    state = const AsyncValue.loading();
    final res =
        await guardAsyncValue(() => shiftRepository.checkIn(shiftId: shiftId));
    if (!mounted) {
      return;
    }
    ref.invalidate(getActivityAndShiftProvider);
    state = res;
  }
}

final checkInControllerProvider =
    StateNotifierProvider.autoDispose<CheckInController, AsyncValue<void>>(
  (ref) => CheckInController(
    ref: ref,
    shiftRepository: ref.watch(shiftRepositoryProvider),
  ),
);

class CheckOutController extends StateNotifier<AsyncValue<void>> {
  final AutoDisposeStateNotifierProviderRef ref;
  final ShiftRepository shiftRepository;

  CheckOutController({
    required this.ref,
    required this.shiftRepository,
  }) : super(const AsyncValue.data(null));

  Future<void> checkOut({required int shiftId}) async {
    if (state.isLoading) {
      return;
    }
    state = const AsyncValue.loading();
    final res = await guardAsyncValue(
      () => shiftRepository.checkOut(shiftId: shiftId),
    );
    if (!mounted) {
      return;
    }
    ref.invalidate(getActivityAndShiftProvider);
    state = res;
  }
}

final checkOutControllerProvider =
    StateNotifierProvider.autoDispose<CheckOutController, AsyncValue<void>>(
  (ref) => CheckOutController(
    ref: ref,
    shiftRepository: ref.watch(shiftRepositoryProvider),
  ),
);
