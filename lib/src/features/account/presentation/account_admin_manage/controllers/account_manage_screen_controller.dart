import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:the_helper/src/features/account/data/account_repository.dart';
import 'package:the_helper/src/features/account/domain/account.dart';

import '../../../../../utils/async_value.dart';
import '../../../domain/account_query.dart';

class AccountManageScreenController extends AutoDisposeAsyncNotifier<void> {
  @override
  build() {}

  Future<AccountModel?> ban(int accountId) async {
    state = const AsyncLoading();
    final res = await guardAsyncValue(() async =>
        await ref.watch(accountRepositoryProvider).banAccount(accId: accountId));
    state = const AsyncData(null);
    return res.valueOrNull;
  }

  Future<AccountModel?> unban(int accountId) async {
    state = const AsyncLoading();
    final res = await guardAsyncValue(() async =>
        await ref.watch(accountRepositoryProvider).unbanAccount(accId: accountId));
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
          query: AccountQuery(
              limit: 5,
              offset: pageKey,
              email: searchPattern,
              isBanned: tabStatus != 0,
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
    if (hasUsedSearch) {
      controller.notifyPageRequestListeners(0);
    }
    return controller;
  },
);
