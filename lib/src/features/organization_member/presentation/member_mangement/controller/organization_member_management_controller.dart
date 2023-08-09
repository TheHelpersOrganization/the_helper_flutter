import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/riverpod_infinite_scroll/riverpod_infinite_scroll.dart';
import 'package:the_helper/src/features/organization/domain/organization.dart';
import 'package:the_helper/src/features/organization/domain/organization_member_role.dart';
import 'package:the_helper/src/features/organization/presentation/switch_organization/switch_organization_controller.dart';
import 'package:the_helper/src/features/organization_member/data/mod_organization_member_repository.dart';
import 'package:the_helper/src/features/organization_member/data/organization_member_repository.dart';
import 'package:the_helper/src/features/organization_member/domain/get_organization_member_query.dart';
import 'package:the_helper/src/features/organization_member/domain/organization_member.dart';
import 'package:the_helper/src/features/organization_member/domain/organization_member_status.dart';
import 'package:the_helper/src/utils/async_value.dart';

import '../screen/organization_member_management_screen.dart';

final currentStatusProvider =
    StateProvider.autoDispose((ref) => tab.first.status);

final hasChangedStatusProvider = StateProvider.autoDispose((ref) => false);

final showSearchProvider = StateProvider.autoDispose((ref) => false);
final searchPatternProvider = StateProvider.autoDispose((ref) => '');

final selectedRoleProvider =
    StateProvider.autoDispose<Set<OrganizationMemberRoleType>>((ref) => {});

final myMemberProvider = FutureProvider.autoDispose((ref) {
  final currentOrganizationId =
      ref.watch(currentOrganizationProvider).valueOrNull!.id;
  return ref.watch(organizationMemberRepositoryProvider).getMe(
        organizationId: currentOrganizationId,
        query: GetOrganizationMemberQuery(
          include: [
            GetOrganizationMemberQueryInclude.role,
          ],
        ),
      );
});

class OrganizationMemberListPagedNotifier
    extends PagedNotifier<int, OrganizationMember> {
  final ModOrganizationMemberRepository modOrganizationMemberRepository;
  final OrganizationMemberStatus status;
  final Organization organization;
  final String searchPattern;
  final Set<OrganizationMemberRoleType> selectedRoles;

  OrganizationMemberListPagedNotifier({
    required this.modOrganizationMemberRepository,
    required this.status,
    required this.organization,
    required this.searchPattern,
    required this.selectedRoles,
  }) : super(
          load: (page, limit) async {
            final items = (await modOrganizationMemberRepository
                    .getMemberWithAccountProfile(
              organization.id,
              query: GetOrganizationMemberQuery(
                name: searchPattern,
                statuses: [status],
                include: [
                  GetOrganizationMemberQueryInclude.profile,
                  GetOrganizationMemberQueryInclude.role,
                ],
                role: selectedRoles.isEmpty ? null : selectedRoles.toList(),
                limit: limit,
                offset: page * limit,
              ),
            ))
                .map(
                  (e) => e.copyWith(
                    organization: organization,
                  ),
                )
                .toList();
            return items;
          },
          nextPageKeyBuilder: NextPageKeyBuilderDefault.mysqlPagination,
        );
}

final organizationMemberListPagedNotifierProvider =
    StateNotifierProvider.autoDispose.family<
        OrganizationMemberListPagedNotifier,
        PagedState<int, OrganizationMember>,
        Organization>(
  (ref, organization) {
    final modOrganizationMemberRepository =
        ref.watch(modOrganizationMemberRepositoryProvider);
    final status = ref.watch(currentStatusProvider);
    final searchPattern = ref.watch(searchPatternProvider);
    final selectedRoles = ref.watch(selectedRoleProvider);

    return OrganizationMemberListPagedNotifier(
      modOrganizationMemberRepository: modOrganizationMemberRepository,
      status: status,
      organization: organization,
      searchPattern: searchPattern,
      selectedRoles: selectedRoles,
    );
  },
);

class ApproveMemberController extends AutoDisposeAsyncNotifier<void> {
  @override
  void build() {}

  Future<OrganizationMember?> approve(int organizationId, int memberId) async {
    state = const AsyncLoading();
    final res = await guardAsyncValue(() async => await ref
        .watch(modOrganizationMemberRepositoryProvider)
        .approve(organizationId: organizationId, memberId: memberId));
    state = const AsyncData(null);
    return res.valueOrNull;
  }
}

class RejectMemberController extends AutoDisposeAsyncNotifier<void> {
  @override
  void build() {}

  Future<OrganizationMember?> reject(
    int organizationId,
    int memberId, {
    String? rejectionReason,
  }) async {
    state = const AsyncLoading();
    final res = await guardAsyncValue(() async => await ref
        .watch(modOrganizationMemberRepositoryProvider)
        .reject(organizationId: organizationId, memberId: memberId));
    state = const AsyncData(null);
    return res.valueOrNull;
  }
}

class RemoveMemberController extends AutoDisposeAsyncNotifier<void> {
  @override
  void build() {}

  Future<OrganizationMember?> remove(int organizationId, int memberId) async {
    state = const AsyncLoading();
    final res = await guardAsyncValue(() async => await ref
        .watch(modOrganizationMemberRepositoryProvider)
        .remove(organizationId: organizationId, memberId: memberId));
    state = const AsyncData(null);
    return res.valueOrNull;
  }
}

class LeaveController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<OrganizationMember?> leave(int organizationId) async {
    state = const AsyncLoading();
    final res = await guardAsyncValue(() async =>
        ref.watch(organizationMemberRepositoryProvider).leave(organizationId));
    state = const AsyncData(null);
    return res.valueOrNull;
  }
}

final approveMemberControllerProvider =
    AutoDisposeAsyncNotifierProvider<ApproveMemberController, void>(
  () => ApproveMemberController(),
);

final rejectMemberControllerProvider =
    AutoDisposeAsyncNotifierProvider<RejectMemberController, void>(
  () => RejectMemberController(),
);

final removeMemberControllerProvider =
    AutoDisposeAsyncNotifierProvider<RemoveMemberController, void>(
  () => RemoveMemberController(),
);

final leaveControllerProvider =
    AutoDisposeAsyncNotifierProvider<LeaveController, void>(
  () => LeaveController(),
);
