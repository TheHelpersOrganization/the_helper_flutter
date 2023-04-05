import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/organization_manage/data/organization_model_repository.dart';
import 'package:the_helper/src/features/organization_manage/domain/organization_model.dart';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class OrganizationManageScreenController
    extends AutoDisposeAsyncNotifier<List<OrganizationModel>> {
  @override
  FutureOr<List<OrganizationModel>> build() {
    return ref.watch(organizationModelRepositoryProvider).getAll();
  }
}

final searchPatternProvider = StateProvider.autoDispose<String?>((ref) => null);
final hasUsedSearchProvider = StateProvider.autoDispose((ref) => false);

final firstLoadPagingController = StateProvider((ref) => true);

final activePagingControllerProvider = Provider.autoDispose(
  (ref) {
    final accountRepository = ref.watch(organizationModelRepositoryProvider);
    final searchPattern = ref.watch(searchPatternProvider);
    final hasUsedSearch = ref.watch(hasUsedSearchProvider);
    final controller = PagingController<int, OrganizationModel>(firstPageKey: 0);
    controller.addPageRequestListener((pageKey) async {
      try {
        final items = await accountRepository.getAll(
          offset: pageKey * 100,
          status: 0,
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

final pendingPagingControllerProvider = Provider.autoDispose(
  (ref) {
    final accountRepository = ref.watch(organizationModelRepositoryProvider);
    final searchPattern = ref.watch(searchPatternProvider);
    final hasUsedSearch = ref.watch(hasUsedSearchProvider);
    final controller = PagingController<int, OrganizationModel>(firstPageKey: 0);
    controller.addPageRequestListener((pageKey) async {
      try {
        final items = await accountRepository.getAll(
          offset: pageKey * 100,
          status: 1,
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
