import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_infinite_scroll/riverpod_infinite_scroll.dart';
import 'package:the_helper/src/features/account/data/account_request_repository.dart';
import 'package:the_helper/src/features/account/domain/account_request.dart';

import '../../../domain/account_request_query.dart';

class AccountRequestManageScreenController
    extends AutoDisposeAsyncNotifier<void> {
  @override
  build() {}
}

final isSearchingProvider = StateProvider.autoDispose<bool>((ref) => false);
final searchPatternProvider = StateProvider.autoDispose<String?>((ref) => null);


final accountRequestManageControllerProvider = AutoDisposeAsyncNotifierProvider<
    AccountRequestManageScreenController, void>(
  () => AccountRequestManageScreenController(),
);

class ScrollPagingControlNotifier extends PagedNotifier<int, AccountRequestModel> {
  final AccountRequestRepository requestRepository;
  final String tabStatus;
  final String? searchPattern;

  ScrollPagingControlNotifier({
    required this.requestRepository,
    required this.tabStatus,
    this.searchPattern,
  }) : super(
          load: (page, limit) {
            return requestRepository.getAll(
              query: AccountRequestQuery(
                limit: limit,
                offset: page * limit,
                status: tabStatus,
              ),
            );
          },
          nextPageKeyBuilder: NextPageKeyBuilderDefault.mysqlPagination,
        );
}

final scrollPagingControlNotifier = StateNotifierProvider.autoDispose
    .family<ScrollPagingControlNotifier, PagedState<int, AccountRequestModel>, String>(
        (ref, index) => ScrollPagingControlNotifier(
            requestRepository: ref.watch(accountRequestRepositoryProvider),
            tabStatus: index,
            searchPattern: ref.watch(searchPatternProvider)));