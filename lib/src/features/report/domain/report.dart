import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../common/domain/file_info.dart';

part 'report.freezed.dart';
part 'report.g.dart';

@freezed
class ReportModel with _$ReportModel {
  factory ReportModel({
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
  }) = _ReportModel;

  factory ReportModel.fromJson(Map<String, dynamic> json) =>
      _$ReportModelFromJson(json);
}
