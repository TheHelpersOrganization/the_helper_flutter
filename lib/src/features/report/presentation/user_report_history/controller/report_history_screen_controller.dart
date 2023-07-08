import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:riverpod_infinite_scroll/riverpod_infinite_scroll.dart';
import 'package:the_helper/src/features/authentication/application/auth_service.dart';
import 'package:the_helper/src/features/report/data/report_repository.dart';
import 'package:the_helper/src/features/report/domain/report_model.dart';
import 'package:the_helper/src/features/report/domain/report_query.dart';

import '../../../../../utils/async_value.dart';
import '../../../domain/report_type.dart';

class ReportHistoryScreenController extends AutoDisposeAsyncNotifier<void> {
  @override
  build() {}
}

final isSearchingProvider = StateProvider.autoDispose<bool>((ref) => false);
final searchPatternProvider = StateProvider.autoDispose<String?>((ref) => null);

class ScrollPagingControlNotifier extends PagedNotifier<int, ReportModel> {
  final ReportRepository requestRepository;
  final ReportType tabStatus;
  final String? searchPattern;

  ScrollPagingControlNotifier({
    required this.requestRepository,
    required this.tabStatus,
    this.searchPattern,
  }) : super(
          load: (page, limit) {
            return requestRepository.getAll(
              query: ReportQuery(
                mine: true,
                limit: limit,
                offset: page * limit,
                type: tabStatus,
              ),
            );
          },
          nextPageKeyBuilder: NextPageKeyBuilderDefault.mysqlPagination,
        );
}

final scrollPagingControlNotifier = StateNotifierProvider.autoDispose.family<
        ScrollPagingControlNotifier, PagedState<int, ReportModel>, ReportType>(
    (ref, index) => ScrollPagingControlNotifier(
        requestRepository: ref.watch(reportRepositoryProvider),
        tabStatus: index,
        searchPattern: ref.watch(searchPatternProvider)));

final reportHistoryControllerProvider =
    AutoDisposeAsyncNotifierProvider<ReportHistoryScreenController, void>(
  () => ReportHistoryScreenController(),
);
