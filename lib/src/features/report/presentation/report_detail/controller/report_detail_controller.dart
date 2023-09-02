import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/report/data/report_repository.dart';
import 'package:the_helper/src/features/report/domain/report_model.dart';
import 'package:the_helper/src/features/report/domain/report_query.dart';

import '../../../domain/report_query_parameter_classes.dart';

part 'report_detail_controller.g.dart';

@riverpod
class ReportDetailController extends _$ReportDetailController {
  @override
  FutureOr<ReportModel> build({required int id}) async {
    return _fetchReportDetail();
  }

  Future<ReportModel> _fetchReportDetail() async {
    final repository = ref.watch(reportRepositoryProvider);
    final data = await repository.getById(
        id: id,
        query: ReportQuery(include: [
          ReportQueryInclude.message,
          ReportQueryInclude.reporter
        ]));
    return data;
  }

  Future<void> approveReport() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
        () => ref.watch(reportRepositoryProvider).approveReport(id: id));
  }

  Future<void> rejectReport() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
        () => ref.watch(reportRepositoryProvider).rejectReport(id: id));
  }

  Future<void> cancelReport() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
        () => ref.watch(reportRepositoryProvider).cancelReport(id: id));
  }
}
