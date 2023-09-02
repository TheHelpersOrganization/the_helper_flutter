import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/report/data/report_repository.dart';
import 'package:the_helper/src/features/report/domain/report_query.dart';

import '../../../utils/dio.dart';
import '../domain/report_log.dart';
import '../domain/report_log_query.dart';
import '../domain/report_query_parameter_classes.dart';

part 'report_service.g.dart';

class ReportService {
  final Dio client;
  final ReportRepository reportRepository;

  const ReportService({
    required this.client,
    required this.reportRepository,
  });

  Future<ReportLog> getLog({
    ReportLogQuery? query,
  }) async {
    ReportLog log = await reportRepository.getLog(query: query);

    return log;
  }
}

@riverpod
ReportService reportService(ReportServiceRef ref) {
  return ReportService(
    client: ref.watch(dioProvider),
    reportRepository: ref.watch(reportRepositoryProvider),
  );
}
