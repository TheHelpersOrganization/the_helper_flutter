import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/riverpod_infinite_scroll/riverpod_infinite_scroll.dart';

import 'package:the_helper/src/features/account/data/account_repository.dart';
import 'package:the_helper/src/features/account/domain/account.dart';

import '../../../../../utils/async_value.dart';
import '../../../domain/account_query.dart';

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

final isSearchingProvider = StateProvider.autoDispose<bool>((ref) => false);
final searchPatternProvider = StateProvider.autoDispose<String?>((ref) => null);
final filterSelectedProvider = StateProvider.autoDispose<bool>((ref) => false);
final verifiedProvider = StateProvider.autoDispose<bool>((ref) => false);

final accountManageControllerProvider =
    AutoDisposeAsyncNotifierProvider<AccountManageScreenController, void>(
  () => AccountManageScreenController(),
);

class ScrollPagingControlNotifier extends PagedNotifier<int, AccountModel> {
  final AccountRepository accountRepository;
  final int tabStatus;
  final String? searchPattern;
  final bool verified;
  final bool filterSelected;

  ScrollPagingControlNotifier({
    required this.accountRepository,
    required this.tabStatus,
    this.searchPattern,
    required this.verified,
    required this.filterSelected,
  }) : super(
          load: (page, limit) {
            return accountRepository.getAll(
              query: AccountQuery(
                limit: limit,
                offset: page * limit,
                email: searchPattern,
                isBanned: tabStatus != 0,
                isVerified: filterSelected
                ? verified
                : null
              ),
            );
          },
          nextPageKeyBuilder: NextPageKeyBuilderDefault.mysqlPagination,
        );
}

final scrollPagingControlNotifier = StateNotifierProvider.autoDispose
    .family<ScrollPagingControlNotifier, PagedState<int, AccountModel>, int>(
        (ref, index) => ScrollPagingControlNotifier(
            accountRepository: ref.watch(accountRepositoryProvider),
            tabStatus: index,
            searchPattern: ref.watch(searchPatternProvider),
            filterSelected: ref.watch(filterSelectedProvider),
            verified: ref.watch(verifiedProvider)));
