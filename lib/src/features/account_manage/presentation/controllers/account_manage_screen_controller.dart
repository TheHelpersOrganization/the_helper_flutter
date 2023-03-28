import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/account_manage/data/account_repository.dart';
import 'package:the_helper/src/features/account_manage/domain/account.dart';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class AccountManageScreenController
    extends AutoDisposeAsyncNotifier<List<AccountModel>> {
  @override
  FutureOr<List<AccountModel>> build() {
    return ref.watch(accountRepositoryProvider).getAll();
  }
}

final pagingControllerProvider = Provider.autoDispose(
  (ref) {
    final accountRepository = ref.watch(accountRepositoryProvider);
    final controller =
        PagingController<int, AccountModel>(firstPageKey: 0);
    controller.addPageRequestListener((pageKey) async {
      try {
        final items = await accountRepository.getAll(
          offset: pageKey * 100,
          isBanned: false,
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
    
    return controller;
  },
);

final bannedPagingControllerProvider = Provider.autoDispose(
  (ref) {
    final accountRepository = ref.watch(accountRepositoryProvider);
    final controller =
        PagingController<int, AccountModel>(firstPageKey: 0);
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
    
    return controller;
  },
);
