import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/report/domain/report_model.dart';
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

  Future<List<ReportModel>> getAll({
    ReportQuery? query,
  }) async {
    final List<dynamic> res = (await client.get(
      '/reports',
      queryParameters: query?.toJson(),
    ))
        .data['data'];
    return res.map((e) => ReportModel.fromJson(e)).toList();
  }

  Future<ReportModel> submitReport(ReportRequest report) async {
    final res = await client.post(
      '/reports',
      data: report.toJson(),
    );
    return ReportModel.fromJson(res.data['data']);
  }

  Future<ReportModel> getById({
    required int id,
    ReportQuery? query,
  }) async {
    final res =
        (await client.get('/reports/$id', queryParameters: query?.toJson()))
            .data['data'];
    return ReportModel.fromJson(res);
  }
}

@riverpod
ReportRepository reportRepository(ReportRepositoryRef ref) =>
    ReportRepository(client: ref.watch(dioProvider));
