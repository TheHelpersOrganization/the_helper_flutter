import 'package:freezed_annotation/freezed_annotation.dart';
// import 'package:the_helper/src/features/report/domain/report_status.dart';

import '../../../common/converter/comma_separated_strings_converter.dart';
import 'report_query_parameter_classes.dart';

part 'report_query.freezed.dart';
part 'report_query.g.dart';



@freezed
class ReportQuery with _$ReportQuery {
  @JsonSerializable(includeIfNull: false)
  factory ReportQuery({
    int? id,
    bool? mine,
    bool? isReviewer,
    int? reporterId,
    String? name,
    @CommaSeparatedStringsConverter() List<String>? type,
    @CommaSeparatedStringsConverter() List<String>? status,
    @CommaSeparatedStringsConverter() List<String>? include,
    @Default([ReportQuerySort.createdTimeAsc]) @CommaSeparatedStringsConverter() List<String>? sort,
    int? limit,
    int? offset,
  }) = _ReportQuery;

  factory ReportQuery.fromJson(Map<String, dynamic> json) =>
      _$ReportQueryFromJson(json);
}
