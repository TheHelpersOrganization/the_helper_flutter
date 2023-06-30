import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/report/data/report_repository.dart';
import 'package:the_helper/src/features/report/domain/admin_report.dart';
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
    // final List<dynamic> res = (await client.get(
    //   '/something',
    //   queryParameters: query?.toJson(),
    // ))
    //     .data['data'];
    // return res.map((e) => ReportModel.fromJson(e)).toList().length;
    return 25;
  }
}

@riverpod
ReportService reportService(ReportServiceRef ref) {
  return ReportService(
    client: ref.watch(dioProvider),
    reportRepository: ref.watch(reportRepositoryProvider),
  );
}
