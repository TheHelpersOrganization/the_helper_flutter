import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/organization/domain/organization_member_role.dart';
import 'package:the_helper/src/features/organization/presentation/switch_organization/switch_organization_controller.dart';
import 'package:the_helper/src/features/organization_member/data/organization_member_repository.dart';
import 'package:the_helper/src/features/organization_member/domain/get_organization_member_query.dart';
import 'package:the_helper/src/features/organization_member/domain/organization_member.dart';
import 'package:the_helper/src/features/organization_member/presentation/member_mangement/controller/organization_member_management_controller.dart';
import 'package:the_helper/src/utils/async_value.dart';

class MemberAndRoles {
  final OrganizationMember member;
  final MemberRoleInfo roleInfo;

  MemberAndRoles({
    required this.member,
    required this.roleInfo,
  });
}

final memberProvider =
    FutureProvider.autoDispose.family<OrganizationMember, int>(
  (ref, memberId) async {
    final organization = await ref.watch(currentOrganizationProvider.future);
    final organizationId = organization!.id!;

    return ref.watch(organizationMemberRepositoryProvider).getMemberById(
        organizationId: organizationId,
        memberId: memberId,
        query: GetOrganizationMemberQuery(
          include: [
            GetOrganizationMemberQueryInclude.profile,
            GetOrganizationMemberQueryInclude.role,
            GetOrganizationMemberQueryInclude.roleGranter,
          ],
        ));
  },
);

final memberRoleInfoProvider =
    FutureProvider.autoDispose.family<MemberRoleInfo, int>(
  (ref, memberId) async {
    final organization = await ref.watch(currentOrganizationProvider.future);
    final organizationId = organization!.id!;

    return ref.watch(organizationMemberRepositoryProvider).getMemberRoleInfo(
          organizationId: organizationId,
          memberId: memberId,
        );
  },
);

final memberAndRolesProvider =
    FutureProvider.autoDispose.family<MemberAndRoles, int>(
  (ref, memberId) async {
    final member = await ref.watch(memberProvider(memberId).future);
    final roles = await ref.watch(memberRoleInfoProvider(memberId).future);
    return MemberAndRoles(
      member: member,
      roleInfo: roles,
    );
  },
);

final selectedRolesProvider = StateProvider.autoDispose<List<int>>(
  (ref) => [],
);

class UpdateRoleController extends AutoDisposeAsyncNotifier<void> {
  late Object? _key;

  @override
  FutureOr<void> build() {
    _key = Object();
    ref.onDispose(() => _key = null);
  }

  Future<void> grantRole({
    required int memberId,
    required OrganizationMemberRoleType role,
  }) async {
    final key = _key;

    state = const AsyncValue.loading();
    final organizationId =
        (await ref.watch(currentOrganizationProvider.future))!.id!;

    final res = await guardAsyncValue(
      () => ref.watch(organizationMemberRepositoryProvider).grantRole(
            organizationId: organizationId,
            memberId: memberId,
            role: role,
          ),
    );

    if (key != _key) {
      return;
    }

    if (res.hasError) {
      state = AsyncValue.error(res.asError!.error, res.stackTrace!);
      return;
    }

    ref.invalidate(memberAndRolesProvider);

    state = const AsyncValue.data(null);
  }

  Future<void> revokeRole({
    required int memberId,
    required OrganizationMemberRoleType role,
  }) async {
    final key = _key;

    state = const AsyncValue.loading();

    final organizationId =
        (await ref.watch(currentOrganizationProvider.future))!.id!;

    final res = await guardAsyncValue(
      () => ref.watch(organizationMemberRepositoryProvider).revokeRole(
            organizationId: organizationId,
            memberId: memberId,
            role: role,
          ),
    );

    if (key != _key) {
      return;
    }

    if (res.hasError) {
      state = AsyncValue.error(res.asError!.error, res.stackTrace!);
      return;
    }

    ref.invalidate(memberAndRolesProvider);
    ref.invalidate(organizationMemberListPagedNotifierProvider);

    state = const AsyncValue.data(null);
  }
}

final updateRoleControllerProvider = AutoDisposeAsyncNotifierProvider(
  () => UpdateRoleController(),
);
