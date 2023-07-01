import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/report/domain/admin_report.dart';
import 'package:the_helper/src/utils/dio.dart';

import '../../../common/domain/file_info.dart';
import '../domain/report_query.dart';
import '../domain/report_request.dart';

part 'report_repository.g.dart';

class ReportRepository {
  final Dio client;

  ReportRepository({
    required this.client,
  });

  Future<List<AdminReportModel>> getAll({
    ReportQuery? query,
  }) async {
    final List<dynamic> res = (await client.get(
      '/reports',
      queryParameters: query?.toJson(),
    ))
        .data['data'];
    return res.map((e) => AdminReportModel.fromJson(e)).toList();
  }

  Future<AdminReportModel> submitReport(ReportRequest report) async {
    final res = await client.post(
      '/reports',
      data: report.toJson(),
    );
    return AdminReportModel.fromJson(res.data['data']);
  }

  Future<AdminReportModel> getById({
    required int id,
    ReportQuery? query,
  }) async {
    final res =
        (await client.get('/reports/$id', queryParameters: query?.toJson()))
            .data['data'];
    return AdminReportModel.fromJson(res);
  }
}

@riverpod
ReportRepository reportRepository(ReportRepositoryRef ref) =>
    ReportRepository(client: ref.watch(dioProvider));
