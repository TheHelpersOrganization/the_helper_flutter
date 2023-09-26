import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/riverpod_infinite_scroll/riverpod_infinite_scroll.dart';
import 'package:the_helper/src/features/account/data/account_repository.dart';
import 'package:the_helper/src/features/account/domain/account.dart';
import 'package:the_helper/src/features/account/domain/account_query.dart';
import 'package:the_helper/src/features/change_role/domain/user_role.dart';
import 'package:the_helper/src/utils/async_value.dart';

final textEditingControllerProvider =
    Provider.autoDispose<TextEditingController>((ref) {
  return TextEditingController();
});
final accountAdminGrantSearchPatternProvider =
    StateProvider.autoDispose<String>((ref) => '');
final accountAdminTabIndexProvider = StateProvider.autoDispose<int>((ref) => 0);

class AccountListPagedNotifier extends PagedNotifier<int, AccountModel> {
  final AccountRepository accountRepository;
  final String searchPattern;
  final int tabIndex;

  AccountListPagedNotifier({
    required this.accountRepository,
    required this.searchPattern,
    required this.tabIndex,
  }) : super(
          load: (page, limit) {
            var accountQuery = AccountQuery(
              search: searchPattern.isEmpty ? null : searchPattern,
              includes: [AccountInclude.profile],
              limit: limit,
              offset: page * limit,
            );
            if (tabIndex == 0) {
              accountQuery = accountQuery.copyWith(role: [Role.admin]);
            } else {
              accountQuery = accountQuery.copyWith(excludeRole: [Role.admin]);
            }
            return accountRepository.getAll(
              query: accountQuery,
            );
          },
          nextPageKeyBuilder: NextPageKeyBuilderDefault.mysqlPagination,
        );
}

final adminAccountListPagedNotifierProvider = StateNotifierProvider.autoDispose<
    AccountListPagedNotifier, PagedState<int, AccountModel>>(
  (ref) {
    final accountRepository = ref.watch(accountRepositoryProvider);
    final searchPattern = ref.watch(accountAdminGrantSearchPatternProvider);
    return AccountListPagedNotifier(
      accountRepository: accountRepository,
      searchPattern: searchPattern,
      tabIndex: 0,
    );
  },
);

final nonAdminAccountListPagedNotifierProvider = StateNotifierProvider
    .autoDispose<AccountListPagedNotifier, PagedState<int, AccountModel>>(
  (ref) {
    final accountRepository = ref.watch(accountRepositoryProvider);
    final searchPattern = ref.watch(accountAdminGrantSearchPatternProvider);
    return AccountListPagedNotifier(
      accountRepository: accountRepository,
      searchPattern: searchPattern,
      tabIndex: 1,
    );
  },
);

class GrantAdminController extends AutoDisposeAsyncNotifier {
  late final AccountRepository _accountRepository;
  @override
  FutureOr build() {
    _accountRepository = ref.watch(accountRepositoryProvider);
  }

  Future<void> grantAdmin(int accountId) async {
    state = const AsyncLoading();
    state = await guardAsyncValue(
      () => _accountRepository.grantAdmin(accountId),
    );
    ref.invalidate(adminAccountListPagedNotifierProvider);
    ref.invalidate(nonAdminAccountListPagedNotifierProvider);
  }
}

final grantAdminControllerProvider = AutoDisposeAsyncNotifierProvider(
  () {
    return GrantAdminController();
  },
);

class RevokeAdminController extends AutoDisposeAsyncNotifier {
  late final AccountRepository _accountRepository;
  @override
  FutureOr build() {
    _accountRepository = ref.watch(accountRepositoryProvider);
  }

  Future<void> revokeAdmin(int accountId) async {
    state = const AsyncLoading();
    state = await guardAsyncValue(
      () => _accountRepository.revokeAdmin(accountId),
    );
    ref.invalidate(adminAccountListPagedNotifierProvider);
    ref.invalidate(nonAdminAccountListPagedNotifierProvider);
  }
}

final revokeAdminControllerProvider = AutoDisposeAsyncNotifierProvider(
  () {
    return RevokeAdminController();
  },
);
