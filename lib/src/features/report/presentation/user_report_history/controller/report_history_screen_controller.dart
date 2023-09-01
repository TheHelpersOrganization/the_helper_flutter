import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:the_helper/src/common/riverpod_infinite_scroll/riverpod_infinite_scroll.dart';
import 'package:the_helper/src/features/report/data/report_repository.dart';
import 'package:the_helper/src/features/report/domain/report_model.dart';
import 'package:the_helper/src/features/report/domain/report_query.dart';

import '../../../domain/report_query_parameter_classes.dart';

class ReportHistoryScreenController extends AutoDisposeAsyncNotifier<void> {
  @override
  build() {}
}

final isSearchingProvider = StateProvider.autoDispose<bool>((ref) => false);
final searchPatternProvider = StateProvider.autoDispose<String?>((ref) => null);

final penddingStatusProvider = StateProvider.autoDispose<bool>((ref) => false);
final reviewingStatusProvider = StateProvider.autoDispose<bool>((ref) => false);
final completedStatusProvider = StateProvider.autoDispose<bool>((ref) => false);
final rejectStatusProvider = StateProvider.autoDispose<bool>((ref) => false);

final sortBySendDateProvider = StateProvider.autoDispose<bool>((ref) => false);
final sortByNewestProvider = StateProvider.autoDispose<bool>((ref) => true);

class ScrollPagingControlNotifier extends PagedNotifier<int, ReportModel> {
  final ReportRepository requestRepository;
  final String tabStatus;
  final String? searchPattern;
  final bool isPendding;
  final bool isReviewing;
  final bool isRejected;
  final bool isCompleted;
  final bool bySendDate;
  final bool byNewest;

  ScrollPagingControlNotifier({
    required this.requestRepository,
    required this.tabStatus,
    this.searchPattern,
    required this.isPendding,
    required this.isReviewing,
    required this.isRejected,
    required this.isCompleted,
    required this.bySendDate,
    required this.byNewest,
  }) : super(
          load: (page, limit) {
            List<String> statusList = [];
            if (isPendding) {
              statusList.add(ReportStatus.pending);
            }
            if (isReviewing) {
              statusList.add(ReportStatus.reviewing);
            }
            if (isRejected) {
              statusList.add(ReportStatus.rejected);
            }
            if (isCompleted) {
              statusList.add(ReportStatus.completed);
            }

            List<String>? sort;
            if (bySendDate) {
              if (byNewest) {
                sort = [ReportQuerySort.createdTimeDesc];
              } else {
                sort = [ReportQuerySort.createdTimeAsc];
              }
            } else {
              if (byNewest) {
                sort = [ReportQuerySort.updatedTimeDesc];
              } else {
                sort = [ReportQuerySort.updatedTimeAsc];
              }
            }
            return requestRepository.getAll(
              query: ReportQuery(
                mine: true,
                limit: limit,
                offset: page * limit,
                type: [tabStatus],
                status: statusList.isEmpty ? null : statusList,
                sort: sort,
              ),
            );
          },
          nextPageKeyBuilder: NextPageKeyBuilderDefault.mysqlPagination,
        );
}

final scrollPagingControlNotifier = StateNotifierProvider.autoDispose
    .family<ScrollPagingControlNotifier, PagedState<int, ReportModel>, String>(
        (ref, index) => ScrollPagingControlNotifier(
            requestRepository: ref.watch(reportRepositoryProvider),
            tabStatus: index,
            searchPattern: ref.watch(searchPatternProvider),
            isPendding: ref.watch(penddingStatusProvider),
            isCompleted: ref.watch(completedStatusProvider),
            isRejected: ref.watch(rejectStatusProvider),
            isReviewing: ref.watch(reviewingStatusProvider),
            bySendDate: ref.watch(sortBySendDateProvider),
            byNewest: ref.watch(sortByNewestProvider)));

final reportHistoryControllerProvider =
    AutoDisposeAsyncNotifierProvider<ReportHistoryScreenController, void>(
  () => ReportHistoryScreenController(),
);
