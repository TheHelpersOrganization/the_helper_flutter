import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:the_helper/src/features/account_manage/data/account_repository.dart';
import 'package:the_helper/src/features/account_manage/domain/account.dart';
import 'package:the_helper/src/features/account_manage/domain/get_account_query.dart';

import '../../../../utils/async_value.dart';

class AccountManageScreenController extends AutoDisposeAsyncNotifier<void> {
  @override
  build() {}

  Future<AccountModel?> ban(int accountId) async {
    state = const AsyncLoading();
    final res = await guardAsyncValue(() async =>
        await ref.watch(accountRepositoryProvider).banAccount(accountId));
    state = const AsyncData(null);
    return res.valueOrNull;
  }

  Future<AccountModel?> unban(int accountId) async {
    state = const AsyncLoading();
    final res = await guardAsyncValue(() async =>
        await ref.watch(accountRepositoryProvider).unbanAccount(accountId));
    state = const AsyncData(null);
    return res.valueOrNull;
  }

  Future<AccountModel?> delete(int accountId) async {
    state = const AsyncLoading();
    final res = await guardAsyncValue(() async =>
        await ref.watch(accountRepositoryProvider).delete(accountId));
    state = const AsyncData(null);
    return res.valueOrNull;
  }
}

final accountManageControllerProvider =
    AutoDisposeAsyncNotifierProvider<AccountManageScreenController, void>(
  () => AccountManageScreenController(),
);

final searchPatternProvider = StateProvider.autoDispose<String?>((ref) => null);
final hasUsedSearchProvider = StateProvider.autoDispose((ref) => false);
final tabStatusProvider = StateProvider.autoDispose<int>((ref) => 0);
final firstLoadPagingController = StateProvider((ref) => true);

final pagingControllerProvider = Provider.autoDispose(
  (ref) {
    final accountRepository = ref.watch(accountRepositoryProvider);
    final searchPattern = ref.watch(searchPatternProvider);
    final hasUsedSearch = ref.watch(hasUsedSearchProvider);
    final tabStatus = ref.watch(tabStatusProvider);
    final controller = PagingController<int, AccountModel>(firstPageKey: 0);
    controller.addPageRequestListener((pageKey) async {
      try {
        final items = await accountRepository.getAll(
          query: GetAccountQuery(
              // query: (name: searchPattern),
              ),
          offset: pageKey * 100,
          isBanned: tabStatus,
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
