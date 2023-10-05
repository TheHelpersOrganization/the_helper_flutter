import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/features/activity/data/activity_repository.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';
import 'package:the_helper/src/features/activity/presentation/mod_activity_management/controller/mod_activity_management_controller.dart';
import 'package:the_helper/src/features/authentication/application/auth_service.dart';
import 'package:the_helper/src/features/authentication/domain/account.dart';
import 'package:the_helper/src/features/location/domain/place_details.dart';
import 'package:the_helper/src/features/organization/data/current_organization_repository.dart';
import 'package:the_helper/src/features/organization_member/data/mod_organization_member_repository.dart';
import 'package:the_helper/src/features/organization_member/domain/organization_member.dart';
import 'package:the_helper/src/features/shift/data/shift_repository.dart';
import 'package:the_helper/src/features/shift/domain/create_shift.dart';
import 'package:the_helper/src/features/shift/domain/shift_skill.dart';
import 'package:the_helper/src/features/skill/data/skill_repository.dart';
import 'package:the_helper/src/features/skill/domain/skill.dart';
import 'package:the_helper/src/router/router.dart';
import 'package:the_helper/src/utils/async_value.dart';

class ActivityAndMember {
  final Activity activity;
  final ActivityManagerData members;

  ActivityAndMember({
    required this.activity,
    required this.members,
  });
}

final activityAndMembersProvider =
    FutureProvider.autoDispose.family<ActivityAndMember, int>(
  (ref, activityId) async {
    final activityRepo = ref.watch(activityRepositoryProvider);
    final activity = await activityRepo.getActivityById(id: activityId);
    final members = await ref.watch(memberDataProvider.future);
    return ActivityAndMember(
      activity: activity,
      members: members,
    );
  },
);

final getSkillsProvider = FutureProvider.autoDispose<List<Skill>>((ref) async {
  final skillRepo = ref.watch(skillRepositoryProvider);
  return skillRepo.getSkills();
});

// Step control
final currentStepProvider = StateProvider.autoDispose((ref) => 0);

// Basic info
final isParticipantLimitedProvider =
    StateProvider.autoDispose<bool?>((ref) => null);

final startDateProvider = StateProvider.autoDispose<DateTime?>((ref) => null);

final locationTextEditingControllerProvider =
    StateProvider.autoDispose<TextEditingController>(
        (ref) => TextEditingController());
final placeProvider = StateProvider<PlaceDetails?>((ref) => null);

// Contact
final selectedContactIdsProvider =
    StateProvider.autoDispose<List<int>?>((ref) => null);
final selectedContactNameProvider =
    StateProvider.autoDispose<String?>((ref) => null);

// Skill
final selectedSkillsProvider =
    StateProvider.autoDispose<List<ShiftSkill>?>((ref) => null);

// Manager
class ActivityManagerData {
  final Account account;
  final List<OrganizationMember> managers;

  ActivityManagerData({
    required this.account,
    required this.managers,
  });
}

final selectedManagersProvider =
    StateProvider.autoDispose<Set<int>?>((ref) => null);
final memberDataProvider = FutureProvider.autoDispose((ref) async {
  final org = await ref
      .watch(currentOrganizationRepositoryProvider)
      .getCurrentOrganizationId();
  final account = await ref.watch(authServiceProvider.future);

  final managers = await ref
      .watch(modOrganizationMemberRepositoryProvider)
      .getMemberWithAccountProfile(org!);

  return ActivityManagerData(
    account: account!.account,
    managers: managers,
  );
});

class CreateShiftController extends StateNotifier<AsyncValue<void>> {
  final AutoDisposeStateNotifierProviderRef ref;
  final ShiftRepository modShiftRepository;
  final GoRouter router;

  CreateShiftController({
    required this.ref,
    required this.modShiftRepository,
    required this.router,
  }) : super(const AsyncData(null));

  Future<void> createShift({required CreateShift shift}) async {
    state = const AsyncValue.loading();
    final res = await guardAsyncValue(
        () => modShiftRepository.createShift(shift: shift));
    ref.invalidate(getActivityAndShiftsProvider);
    if (!mounted) {
      return;
    }
    if (res.hasError) {
      state = AsyncError(res.error!, res.stackTrace!);
      return;
    }
    router.goNamed(AppRoute.organizationShift.name, pathParameters: {
      'activityId': shift.activityId.toString(),
      'shiftId': res.value!.id.toString()
    });
    state = const AsyncValue.data(null);
  }
}

final createShiftControllerProvider =
    StateNotifierProvider.autoDispose<CreateShiftController, AsyncValue<void>>(
  (ref) => CreateShiftController(
    ref: ref,
    modShiftRepository: ref.watch(shiftRepositoryProvider),
    router: ref.watch(routerProvider),
  ),
);
