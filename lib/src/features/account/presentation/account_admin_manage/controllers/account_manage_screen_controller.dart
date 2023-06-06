import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:the_helper/src/features/account/data/account_repository.dart';
import 'package:the_helper/src/features/account/domain/account.dart';

import '../../../../../utils/async_value.dart';
import '../../../domain/account_query.dart';

part 'account_manage_screen_controller.g.dart';

class AccountManageScreenController extends AutoDisposeAsyncNotifier<void> {
  @override
  build() {}

  Future<AccountModel?> ban(int accountId) async {
    state = const AsyncLoading();
    final res = await guardAsyncValue(() =>
        ref.watch(accountRepositoryProvider).banAccount(accId: accountId));
    state = const AsyncData(null);
    return res.valueOrNull;
  }

  Future<AccountModel?> unban(int accountId) async {
    state = const AsyncLoading();
    final res = await guardAsyncValue(() =>
        ref.watch(accountRepositoryProvider).unbanAccount(accId: accountId));
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

@riverpod
class ScrollPagingController extends _$ScrollPagingController {
  @override
  PagingController<int, AccountModel> build() {
    final searchPattern = ref.watch(searchPatternProvider);
    final tabStatus = ref.watch(tabStatusProvider);
    final controller = PagingController<int, AccountModel>(firstPageKey: 0);
    controller.addPageRequestListener((pageKey) {
      fetchPage(
        pageKey: pageKey,
        searchPattern: searchPattern,
        tabStatus: tabStatus,
      );
    });
    return controller;
  }

  Future<void> fetchPage({
    required int pageKey,
    String? searchPattern,
    required int tabStatus,
  }) async {
    final accountRepository = ref.watch(accountRepositoryProvider);
    final items = await guardAsyncValue<List<AccountModel>>(
        () => accountRepository.getAll(
              query: AccountQuery(
                limit: 5,
                offset: pageKey,
                email: searchPattern,
                isBanned: tabStatus != 0,
              ),
            ));
    items.whenData((value) {
      final isLastPage = value.length < 100;
      if (isLastPage) {
        state.appendLastPage(value);
      } else {
        state.appendPage(value, pageKey + 1);
      }
    });
  }

  void refreshOnSearch() {
    state.notifyPageRequestListeners(0);
  }

  void reloadPage() {
    state.refresh();
  }
}

final accountManageControllerProvider =
    AutoDisposeAsyncNotifierProvider<AccountManageScreenController, void>(
  () => AccountManageScreenController(),
);

final searchPatternProvider = StateProvider.autoDispose<String?>((ref) => null);
final needReloadProvider = StateProvider.autoDispose((ref) => false);
final tabStatusProvider = StateProvider.autoDispose<int>((ref) => 0);
final firstLoadPagingController = StateProvider((ref) => true);

final pagingControllerProvider = Provider.autoDispose(
  (ref) {
    final accountRepository = ref.watch(accountRepositoryProvider);
    final searchPattern = ref.watch(searchPatternProvider);
    final needReload = ref.watch(needReloadProvider);
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
    if (needReload) {
      controller.notifyPageRequestListeners(0);
    }
    return controller;
  },
);
