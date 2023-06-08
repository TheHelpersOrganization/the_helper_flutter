import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/features/activity/application/activity_service.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_management/controller/mod_activity_management_controller.dart';
import 'package:the_helper/src/features/profile/data/profile_repository.dart';
import 'package:the_helper/src/features/profile/domain/get_profiles_data.dart';
import 'package:the_helper/src/features/shift/data/mod_shift_repository.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';
import 'package:the_helper/src/features/shift/domain/shift_query.dart';
import 'package:the_helper/src/router/router.dart';
import 'package:the_helper/src/utils/async_value.dart';

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

class DeleteShiftController extends StateNotifier<AsyncValue<void>> {
  final AutoDisposeStateNotifierProviderRef ref;
  final ModShiftRepository modShiftRepository;
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
    modShiftRepository: ref.watch(modShiftRepositoryProvider),
    router: ref.watch(routerProvider),
  ),
);
