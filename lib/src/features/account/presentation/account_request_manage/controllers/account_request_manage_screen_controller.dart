import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/account/data/account_request_repository.dart';
import 'package:the_helper/src/features/account/domain/account_request.dart';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class AccountRequestManageScreenController
    extends AutoDisposeAsyncNotifier<List<AccountRequestModel>> {
  @override
  FutureOr<List<AccountRequestModel>> build() {
    return ref.watch(accountRequestRepositoryProvider).getAll();
  }
}

final searchPatternProvider = StateProvider.autoDispose<String?>((ref) => null);
final hasUsedSearchProvider = StateProvider.autoDispose((ref) => false);

final firstLoadPagingController = StateProvider((ref) => true);

final penddingPagingControllerProvider = Provider.autoDispose(
  (ref) {
    final accountRepository = ref.watch(accountRequestRepositoryProvider);
    final searchPattern = ref.watch(searchPatternProvider);
    final hasUsedSearch = ref.watch(hasUsedSearchProvider);
    final controller = PagingController<int, AccountRequestModel>(firstPageKey: 0);
    controller.addPageRequestListener((pageKey) async {
      try {
        final items = await accountRepository.getAll(
          offset: pageKey * 100,
          isBanned: false,
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

final approvedPagingControllerProvider = Provider.autoDispose(
  (ref) {
    final accountRepository = ref.watch(accountRequestRepositoryProvider);
    final searchPattern = ref.watch(searchPatternProvider);
    final hasUsedSearch = ref.watch(hasUsedSearchProvider);
    final controller = PagingController<int, AccountRequestModel>(firstPageKey: 0);
    controller.addPageRequestListener((pageKey) async {
      try {
        final items = await accountRepository.getAll(
          offset: pageKey * 100,
          isBanned: true,
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

final rejectedPagingControllerProvider = Provider.autoDispose(
  (ref) {
    final accountRepository = ref.watch(accountRequestRepositoryProvider);
    final searchPattern = ref.watch(searchPatternProvider);
    final hasUsedSearch = ref.watch(hasUsedSearchProvider);
    final controller = PagingController<int, AccountRequestModel>(firstPageKey: 0);
    controller.addPageRequestListener((pageKey) async {
      try {
        final items = await accountRepository.getAll(
          offset: pageKey * 100,
          isBanned: true,
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
