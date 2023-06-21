import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/report/domain/report.dart';
import 'package:the_helper/src/utils/dio.dart';

import '../../../common/domain/file_info.dart';
import '../domain/report_query.dart';

part 'report_repository.g.dart';

List<ReportModel> tRes = [
  ReportModel(
      senderId: 1,
      senderName: 'senderName',
      accusedId: 2,
      accusedName: 'accusedName',
      type: 'user',
      reportType: 'reportType',
      note: 'asdfaoi uhfasioudnvas dug has odfja iefh asun dvarfasd',
      createdAt: DateTime.utc(2023, 1, 1, 06, 00 ,00),
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
      ]
    ),
];

class ReportRepository {
  final Dio client;

  ReportRepository({
    required this.client,
  });

  Future<List<ReportModel>> getAll({
    ReportQuery? query,
  }) async {
    // final List<dynamic> res = (await client.get(
    //   'something',
    //   queryParameters: query?.toJson(),
    // ))
    //     .data['data'];
    // return res.map((e) => ReportModel.fromJson(e)).toList();
    final List<ReportModel> res = tRes;
    return res;
  }
}

@riverpod
ReportRepository reportRepository(ReportRepositoryRef ref) =>
    ReportRepository(client: ref.watch(dioProvider));
