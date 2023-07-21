import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/riverpod_infinite_scroll/riverpod_infinite_scroll.dart';
import 'package:the_helper/src/features/account/data/account_request_repository.dart';
import 'package:the_helper/src/features/account/domain/account_request.dart';
import 'package:the_helper/src/features/profile/application/profile_service.dart';
import 'package:the_helper/src/features/profile/data/profile_repository.dart';
import 'package:the_helper/src/features/profile/domain/profile.dart';

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

class ScrollPagingControlNotifier
    extends PagedNotifier<int, AccountRequestModel> {
  final AccountRequestRepository requestRepository;
  final ProfileRepository profileRepository;
  final AccountRequestStatus tabStatus;
  final String? searchPattern;

  ScrollPagingControlNotifier({
    required this.requestRepository,
    required this.tabStatus,
    required this.profileRepository,
    this.searchPattern,
  }) : super(
          load: (page, limit) {
            return requestRepository.getAll(
              query: AccountRequestQuery(
                limit: limit,
                offset: page * limit,
                status: tabStatus,
                include: [AccountRequestInclude.file]
              ),
            );
          },
          nextPageKeyBuilder: NextPageKeyBuilderDefault.mysqlPagination,
        );
}

final scrollPagingControlNotifier = StateNotifierProvider.autoDispose.family<
        ScrollPagingControlNotifier,
        PagedState<int, AccountRequestModel>,
        AccountRequestStatus>(
    (ref, index) => ScrollPagingControlNotifier(
        requestRepository: ref.watch(accountRequestRepositoryProvider),
        profileRepository: ref.watch(profileRepositoryProvider),
        tabStatus: index,
        searchPattern: ref.watch(searchPatternProvider)));
