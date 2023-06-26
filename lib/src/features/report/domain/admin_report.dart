import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../common/domain/file_info.dart';

part 'admin_report.freezed.dart';
part 'admin_report.g.dart';

@freezed
class AdminReportModel with _$AdminReportModel {
  factory AdminReportModel({
    int? id,
    required int senderId,
    required String senderName,
    required int accusedId,
    required String accusedName,
    int? accusedAvaId,
    required String type,
    required String reportType,
    String? note,
    required DateTime createdAt,
    required List<FileInfoModel> files,
  }) = _AdminReportModel;

  factory AdminReportModel.fromJson(Map<String, dynamic> json) =>
      _$AdminReportModelFromJson(json);
}
