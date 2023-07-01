import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../common/domain/file_info.dart';
import 'account_data.dart';

part 'report_message.freezed.dart';
part 'report_message.g.dart';

@freezed
class ReportMessageModel with _$ReportMessageModel {
  factory ReportMessageModel({
    int? id,
    required int senderId,
    required AccountData sender,
    required String content,
    List<FileInfoModel>? files,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ReportMessageModel;

  factory ReportMessageModel.fromJson(Map<String, dynamic> json) =>
      _$ReportMessageModelFromJson(json);
}
