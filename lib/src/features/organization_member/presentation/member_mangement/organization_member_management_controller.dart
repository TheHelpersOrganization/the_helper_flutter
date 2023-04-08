import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:the_helper/src/features/organization/presentation/switch_organization/switch_organization_controller.dart';
import 'package:the_helper/src/features/organization_member/data/mod_organization_member_repository.dart';
import 'package:the_helper/src/features/organization_member/domain/get_organization_member_data.dart';
import 'package:the_helper/src/features/organization_member/domain/organization_member.dart';
import 'package:the_helper/src/utils/async_value.dart';

import 'organization_member_management_screen.dart';

final currentStatusProvider =
    StateProvider.autoDispose((ref) => tab.first.status);

final hasChangedStatusProvider = StateProvider.autoDispose((ref) => false);

final pagingControllerProvider = Provider.autoDispose(
  (ref) {
    final hasChangedStatus = ref.watch(hasChangedStatusProvider);
    final currentStatus = ref.watch(currentStatusProvider);
    final currentOrganization =
        ref.watch(currentOrganizationProvider).valueOrNull;
    final organizationMemberRepo =
        ref.watch(modOrganizationMemberRepositoryProvider);
    final controller =
        PagingController<int, OrganizationMember>(firstPageKey: 0);
    controller.addPageRequestListener((pageKey) async {
      try {
        if (currentOrganization == null) {
          return;
        }
        var items = await organizationMemberRepo.getMemberWithAccountProfile(
          currentOrganization.id!,
          data: GetOrganizationMemberData(
            statuses: [currentStatus],
          ),
        );
        items = items
            .map(
              (e) => e.copyWith(organization: currentOrganization),
            )
            .toList();
        final isLastPage = items.length < 100;
        if (isLastPage) {
          controller.appendLastPage(items);
        } else {
          controller.appendPage(items, pageKey + 1);
        }
      } catch (err) {
        controller.error = err;
      }
    });
    controller.notifyPageRequestListeners(0);

    return controller;
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
