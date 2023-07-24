import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/report/data/report_repository.dart';
import 'package:the_helper/src/features/report/domain/report_query.dart';

import '../../../utils/dio.dart';

part 'report_service.g.dart';

class ReportService {
  final Dio client;
  final ReportRepository reportRepository;

  const ReportService({
    required this.client,
    required this.reportRepository,
  });

  Future<int> getCount({
    ReportQuery? query,
  }) async {
    final res = await reportRepository.getAll(
      query: ReportQuery(status: [ReportStatus.pending])
    );
    return res.length;
  }
}

@riverpod
ReportService reportService(ReportServiceRef ref) {
  return ReportService(
    client: ref.watch(dioProvider),
    reportRepository: ref.watch(reportRepositoryProvider),
  );
}
