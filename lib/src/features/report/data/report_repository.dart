import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/report/domain/admin_report.dart';
import 'package:the_helper/src/utils/dio.dart';

import '../../../common/domain/file_info.dart';
import '../domain/report_model.dart';
import '../domain/report_query.dart';
import '../domain/report_type.dart';

part 'report_repository.g.dart';

List<AdminReportModel> tRes = [
  AdminReportModel(
      senderId: 1,
      senderName: 'senderName',
      accusedId: 2,
      accusedName: 'accusedName',
      type: 'user',
      reportType: 'reportType',
      note: 'asdfaoi uhfasioudnvas dug has odfja iefh asun dvarfasd',
      createdAt: DateTime.utc(2023, 1, 1, 06, 00, 00),
      files: [
        FileInfoModel(
            name: "Filename",
            internalName: "internalName",
            mimetype: "mimetype",
            size: 200,
            sizeUnit: "sizeUnit"),
        FileInfoModel(
            name: "ADF",
            internalName: "internalName",
            mimetype: "mimetype",
            size: 20,
            sizeUnit: "sizeUnit"),
      ]),
];

List<ReportType> rpType = [
  ReportType(id: 1, name: 'name', entityType: 'entityType'),
  ReportType(id: 2, name: 'asdf', entityType: 'entityType'),
  ReportType(id: 3, name: '2dsdad', entityType: 'entityType')
];

class ReportRepository {
  final Dio client;

  ReportRepository({
    required this.client,
  });

  Future<List<AdminReportModel>> getAll({
    ReportQuery? query,
  }) async {
    // final List<dynamic> res = (await client.get(
    //   'something',
    //   queryParameters: query?.toJson(),
    // ))
    //     .data['data'];
    // return res.map((e) => ReportModel.fromJson(e)).toList();
    final List<AdminReportModel> res = tRes;
    return res;
  }

  Future<ReportModel> submitReport(ReportModel report) async {
    // final res = await client.post(
    //   '/something',
    //   data: report.toJson(),
    // );
    // return ReportModel.fromJson(res.data['data']);
    return report;
  }

  Future<AdminReportModel> getById({
    required int id,
  }) async {
    final res = (await client.get('/something')).data['data'];
    return AdminReportModel.fromJson(res);
  }

  Future<List<ReportType>> getReportTypeList({
    required String entityType,
  }) async {
    // final List<dynamic> res = (await client.get('/something')).data['data'];
    // return res.map((e) => ReportType.fromJson(e)).toList();
    return rpType;
  }
}

@riverpod
ReportRepository reportRepository(ReportRepositoryRef ref) =>
    ReportRepository(client: ref.watch(dioProvider));
