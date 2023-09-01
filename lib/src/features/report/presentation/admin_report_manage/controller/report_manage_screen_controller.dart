import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:the_helper/src/common/riverpod_infinite_scroll/riverpod_infinite_scroll.dart';
import 'package:the_helper/src/features/report/data/report_repository.dart';
import 'package:the_helper/src/features/report/domain/report_model.dart';
import 'package:the_helper/src/features/report/domain/report_query.dart';

import '../../../domain/report_query_parameter_classes.dart';

class ReportManageScreenController extends AutoDisposeAsyncNotifier<void> {
  @override
  build() {}
}

final isSearchingProvider = StateProvider.autoDispose<bool>((ref) => false);
final searchPatternProvider = StateProvider.autoDispose<String?>((ref) => null);
final filterAccountProvider = StateProvider.autoDispose<bool>((ref) => false);
final filterOrganizationProvider =
    StateProvider.autoDispose<bool>((ref) => false);
final filterActivityProvider = StateProvider.autoDispose<bool>((ref) => false);
final filterNewsProvider = StateProvider.autoDispose<bool>((ref) => false);

final sortBySendDateProvider = StateProvider.autoDispose<bool>((ref) => false);
final sortByNewestProvider = StateProvider.autoDispose<bool>((ref) => true);

class ScrollPagingControlNotifier extends PagedNotifier<int, ReportModel> {
  final ReportRepository requestRepository;
  final String tabStatus;
  final String? searchPattern;
  final bool filterAccount;
  final bool filterOrg;
  final bool filterActivity;
  final bool filterNews;
  final bool bySendDate;
  final bool byNewest;

  ScrollPagingControlNotifier({
    required this.requestRepository,
    required this.tabStatus,
    this.searchPattern,
    required this.filterAccount,
    required this.filterOrg,
    required this.filterActivity,
    required this.filterNews,
    required this.bySendDate,
    required this.byNewest,
  }) : super(
          load: (page, limit) {
            List<String> typeList = [];
            if (filterAccount) {
              typeList.add(ReportType.account);
            }
            if (filterOrg) {
              typeList.add(ReportType.organization);
            }
            if (filterActivity) {
              typeList.add(ReportType.activity);
            }
            if (filterNews) {
              typeList.add(ReportType.news);
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
                limit: limit,
                offset: page * limit,
                status: [tabStatus],
                type: typeList.isEmpty ? null : typeList,
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
            filterAccount: ref.watch(filterAccountProvider),
            filterOrg: ref.watch(filterOrganizationProvider),
            filterActivity: ref.watch(filterActivityProvider),
            filterNews: ref.watch(filterNewsProvider),
            bySendDate: ref.watch(sortBySendDateProvider),
            byNewest: ref.watch(sortByNewestProvider)));
