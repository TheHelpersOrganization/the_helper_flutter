import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/organization/data/admin_organization_repository.dart';
import 'package:the_helper/src/features/organization/domain/organization.dart';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class OrganizationManageScreenController
    extends AutoDisposeAsyncNotifier<List<Organization>> {
  @override
  FutureOr<List<Organization>> build() {
    return ref.watch(adminOrganizationRepositoryProvider).get();
  }
}

final searchPatternProvider = StateProvider.autoDispose<String?>((ref) => null);
final hasUsedSearchProvider = StateProvider.autoDispose((ref) => false);
final tabStatusProvider = StateProvider.autoDispose<int?>((ref) => 0);
final firstLoadPagingController = StateProvider((ref) => true);

final pagingControllerProvider = Provider.autoDispose(
  (ref) {
    final organizationRepo = ref.watch(adminOrganizationRepositoryProvider);
    final searchPattern = ref.watch(searchPatternProvider);
    final hasUsedSearch = ref.watch(hasUsedSearchProvider);
    final tabStatus = ref.watch(tabStatusProvider);
    final controller = PagingController<int, Organization>(firstPageKey: 0);
    controller.addPageRequestListener((pageKey) async {
      try {
        final items = await organizationRepo.get(
          offset: pageKey * 100,
          status: tabStatus,
          // query: (name: searchPattern),
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
    if (hasUsedSearch) {
      controller.notifyPageRequestListeners(0);
    }
    return controller;
  },
);
