import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/account/data/account_request_repository.dart';
import 'package:the_helper/src/features/account/domain/account_request.dart';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:the_helper/src/features/organization/presentation/my/my_organization_screen.dart';

import '../../../../../utils/async_value.dart';
import '../../../domain/account_request_query.dart';

part 'account_request_manage_screen_controller.g.dart';

class AccountRequestManageScreenController
    extends AutoDisposeAsyncNotifier<void> {
  @override
  build() {}
}

final searchPatternProvider = StateProvider.autoDispose<String?>((ref) => null);
final needReloadProvider = StateProvider.autoDispose((ref) => false);
final firstLoadPagingController = StateProvider((ref) => true);

@riverpod
class TabStatus extends _$TabStatus {
  @override
  String build() {
    return 'pending';
  }

  void changeStatus(int index) {
    switch(index) {
      case 1:
        state = 'completed';
        break;
      case 2:
        state = 'rejected';
        break;
      default:
        state = 'pending';
        break;
    }
  }
}

@riverpod
class ScrollPagingController extends _$ScrollPagingController {
  @override
  PagingController<int, AccountRequestModel> build() {
    final searchPattern = ref.watch(searchPatternProvider);
    final tabStatus = ref.watch(tabStatusProvider);
    final controller =
        PagingController<int, AccountRequestModel>(firstPageKey: 0);
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
    required String tabStatus,
  }) async {
    final accountRepository = ref.watch(accountRequestRepositoryProvider);
    final items = await guardAsyncValue<List<AccountRequestModel>>(
        () => accountRepository.getAll(
              query: AccountRequestQuery(
                limit: 10,
                offset: pageKey,
                status: tabStatus,
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

final accountManageControllerProvider = AutoDisposeAsyncNotifierProvider<
    AccountRequestManageScreenController, void>(
  () => AccountRequestManageScreenController(),
);
