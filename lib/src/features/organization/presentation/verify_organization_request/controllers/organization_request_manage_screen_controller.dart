import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/organization/data/organization_request_repository.dart';
import 'package:the_helper/src/features/organization/domain/organization_request_model.dart';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class OrganizationRequestManageScreenController
    extends AutoDisposeAsyncNotifier<List<OrganizationRequestModel>> {
  @override
  FutureOr<List<OrganizationRequestModel>> build() {
    return ref.watch(organizationRequestModelRepositoryProvider).getAll();
  }
}

final searchPatternProvider = StateProvider.autoDispose<String?>((ref) => null);
final hasUsedSearchProvider = StateProvider.autoDispose((ref) => false);
final tabStatusProvider = StateProvider.autoDispose<int?>((ref) => 0);
final firstLoadPagingController = StateProvider((ref) => true);

final pagingControllerProvider = Provider.autoDispose(
  (ref) {
    print('dfs');
    final requestRepo = ref.watch(organizationRequestModelRepositoryProvider);
    final searchPattern = ref.watch(searchPatternProvider);
    final hasUsedSearch = ref.watch(hasUsedSearchProvider);
    final tabStatus = ref.watch(tabStatusProvider);
    final controller =
        PagingController<int, OrganizationRequestModel>(firstPageKey: 0);
    controller.addPageRequestListener((pageKey) async {
      try {
        final items = await requestRepo.getAll(
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
