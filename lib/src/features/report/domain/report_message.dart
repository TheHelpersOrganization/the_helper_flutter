import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../common/domain/file_info.dart';
import 'account_data.dart';

part 'report_message.freezed.dart';
part 'report_message.g.dart';

@freezed
class ReportMessage with _$ReportMessage {
  factory ReportMessage({
    int? id,
    required int senderId,
    required AccountData sender,
    required String content,
    List<FileInfoModel>? files,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ReportMessage;

  factory ReportMessage.fromJson(Map<String, dynamic> json) =>
      _$ReportMessageFromJson(json);
}
