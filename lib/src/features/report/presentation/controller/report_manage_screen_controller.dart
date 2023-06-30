import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:the_helper/src/features/report/data/report_repository.dart';
import 'package:the_helper/src/features/report/domain/admin_report.dart';
import 'package:the_helper/src/features/report/domain/report_query.dart';

import '../../../../utils/async_value.dart';

part 'report_manage_screen_controller.g.dart';

class ReportManageScreenController extends AutoDisposeAsyncNotifier<void> {
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
    return 'account';
  }

  void changeStatus(int index) {
    switch (index) {
      case 1:
        state = 'organization';
        break;
      case 2:
        state = 'activity';
        break;
      default:
        state = 'account';
        break;
    }
  }
}

@riverpod
class ScrollPagingController extends _$ScrollPagingController {
  @override
  PagingController<int, AdminReportModel> build() {
    final searchPattern = ref.watch(searchPatternProvider);
    final tabStatus = ref.watch(tabStatusProvider);
    final controller = PagingController<int, AdminReportModel>(firstPageKey: 0);
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
    final accountRepository = ref.watch(reportRepositoryProvider);
    final items = await guardAsyncValue<List<AdminReportModel>>(
        () => accountRepository.getAll(
              query: ReportQuery(
                limit: 5,
                offset: pageKey,
                type: tabStatus,
                include: [
                  "reporter",
                  "message"
                ]
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

final reportManageControllerProvider =
    AutoDisposeAsyncNotifierProvider<ReportManageScreenController, void>(
  () => ReportManageScreenController(),
);
