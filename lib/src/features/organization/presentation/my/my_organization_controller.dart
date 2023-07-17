import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:the_helper/src/features/organization/data/organization_repository.dart';
import 'package:the_helper/src/features/organization_member/data/organization_member_repository.dart';
import 'package:the_helper/src/features/organization_member/domain/organization_member.dart';
import 'package:the_helper/src/utils/async_value.dart';

import '../../domain/organization.dart';
import '../../domain/organization_query.dart';
import 'my_organization_screen.dart';

final currentStatusProvider =
    StateProvider.autoDispose((ref) => tab.first.status);

final hasChangedStatusProvider = StateProvider.autoDispose((ref) => false);

final myPagingControllerProvider = Provider.autoDispose(
  (ref) {
    final hasChangedStatus = ref.watch(hasChangedStatusProvider);
    final currentState = ref.watch(currentStatusProvider);
    final organizationRepo = ref.watch(organizationRepositoryProvider);
    final controller = PagingController<int, Organization>(firstPageKey: 0);
    controller.addPageRequestListener((pageKey) async {
      try {
        final items = await organizationRepo.getAll(
          query: OrganizationQuery(
            offset: pageKey * 100,
            memberStatus: currentState,
            joined: true,
          ),
        );
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
    if (hasChangedStatus) {
      controller.notifyPageRequestListeners(0);
    }
    return controller;
  },
);

class CancelJoinController extends AutoDisposeAsyncNotifier<void> {
  @override
  void build() {}

  Future<OrganizationMember?> cancel(int organizationId) async {
    state = const AsyncLoading();
    final res = await guardAsyncValue(() async => await ref
        .watch(organizationMemberRepositoryProvider)
        .cancel(organizationId));
    state = const AsyncData(null);
    return res.valueOrNull;
  }
}

final cancelJoinControllerProvider =
    AutoDisposeAsyncNotifierProvider(() => CancelJoinController());
