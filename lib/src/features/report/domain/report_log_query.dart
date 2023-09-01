import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/common/converter/comma_separated_strings_converter.dart';

part 'report_log_query.freezed.dart';
part 'report_log_query.g.dart';

@freezed
class ReportLogQuery with _$ReportLogQuery {
  @JsonSerializable(includeIfNull: false)
  factory ReportLogQuery({
    int? startTime,
    int? endTime,
    @CommaSeparatedStringsConverter() List<String>? type,
    @CommaSeparatedStringsConverter() List<String>? status,
  }) = _ReportLogQuery;

  factory ReportLogQuery.fromJson(Map<String, dynamic> json) =>
      _$ReportLogQueryFromJson(json);
}
