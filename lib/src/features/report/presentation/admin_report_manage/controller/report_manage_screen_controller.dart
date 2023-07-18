
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:riverpod_infinite_scroll/riverpod_infinite_scroll.dart';
import 'package:the_helper/src/features/report/data/report_repository.dart';
import 'package:the_helper/src/features/report/domain/report_model.dart';
import 'package:the_helper/src/features/report/domain/report_query.dart';

import '../../../domain/report_status.dart';

class ReportManageScreenController extends AutoDisposeAsyncNotifier<void> {
  @override
  build() {}
}

final isSearchingProvider = StateProvider.autoDispose<bool>((ref) => false);
final searchPatternProvider = StateProvider.autoDispose<String?>((ref) => null);


class ScrollPagingControlNotifier extends PagedNotifier<int, ReportModel> {
  final ReportRepository requestRepository;
  final ReportStatus tabStatus;
  final String? searchPattern;

  ScrollPagingControlNotifier({
    required this.requestRepository,
    required this.tabStatus,
    this.searchPattern,
  }) : super(
          load: (page, limit) {
            return requestRepository.getAll(
              query: ReportQuery(
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
    .family<ScrollPagingControlNotifier, PagedState<int, ReportModel>, ReportStatus>(
        (ref, index) => ScrollPagingControlNotifier(
            requestRepository: ref.watch(reportRepositoryProvider),
            tabStatus: index,
            searchPattern: ref.watch(searchPatternProvider)));
