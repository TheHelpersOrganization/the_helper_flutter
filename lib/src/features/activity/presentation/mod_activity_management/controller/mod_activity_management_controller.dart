import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/features/activity/application/activity_service.dart';
import 'package:the_helper/src/features/activity/data/activity_repository.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_list_management/controller/mod_activity_list_management_controller.dart';
import 'package:the_helper/src/features/organization_member/data/organization_member_repository.dart';
import 'package:the_helper/src/features/organization_member/domain/get_organization_member_query.dart';
import 'package:the_helper/src/features/profile/data/profile_repository.dart';
import 'package:the_helper/src/features/profile/domain/get_profiles_data.dart';
import 'package:the_helper/src/features/profile/domain/profile.dart';
import 'package:the_helper/src/features/shift/data/shift_repository.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';
import 'package:the_helper/src/features/shift/domain/shift_query.dart';
import 'package:the_helper/src/features/shift/presentation/mod_shift/controller/shift_controller.dart';
import 'package:the_helper/src/router/router.dart';
import 'package:the_helper/src/utils/async_value.dart';

enum TabType {
  shift,
  overview,
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

final currentTabProvider =
    StateProvider.autoDispose<TabType>((ref) => TabType.shift);

// Filter
final isShiftManagerSelectedProvider =
    StateProvider.autoDispose((ref) => false);

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
    final shifts = await ref.watch(shiftRepositoryProvider).getShifts(
          query: ShiftQuery(
            activityId: activityId,
            include: [
              ShiftQueryInclude.shiftSkill,
              ShiftQueryInclude.shiftManager,
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

final myMemberProvider = FutureProvider.autoDispose((ref) async {
  return ref.watch(organizationMemberRepositoryProvider).getMe(
        organizationId:
            (await ref.watch(currentOrganizationProvider.future))!.id,
        query: GetOrganizationMemberQuery(
          include: [
            GetOrganizationMemberQueryInclude.role,
          ],
        ),
      );
});

class DeleteActivityController extends StateNotifier<AsyncValue<void>> {
  final AutoDisposeStateNotifierProviderRef ref;
  final ActivityRepository activityRepository;
  final GoRouter router;

  DeleteActivityController({
    required this.ref,
    required this.activityRepository,
    required this.router,
  }) : super(const AsyncValue.data(null));

  Future<void> deleteActivity({
    required int activityId,
    bool navigateToActivityListManagement = true,
  }) async {
    state = const AsyncValue.loading();
    final res = await guardAsyncValue(
      () => activityRepository.deleteActivity(
        activityId: activityId,
      ),
    );
    if (!res.hasError) {
      ref.invalidate(getActivityAndShiftsProvider);
      ref.invalidate(getActivityAndShiftProvider);
      ref.invalidate(getActivityProvider);
      ref.invalidate(pagingControllerProvider);
    }
    if (!mounted) {
      return;
    }
    state = res;
    if (navigateToActivityListManagement) {
      router.goNamed(
        AppRoute.organizationActivityListManagement.name,
      );
    }
  }
}

final deleteActivityControllerProvider = StateNotifierProvider.autoDispose<
    DeleteActivityController, AsyncValue<void>>(
  (ref) => DeleteActivityController(
    ref: ref,
    activityRepository: ref.watch(
      activityRepositoryProvider,
    ),
    router: ref.watch(routerProvider),
  ),
);
