import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/common/converter/comma_separated_datetimes_converter.dart';

import '../../../common/converter/comma_separated_strings_converter.dart';

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
    String? type,
    String? sort,
    @CommaSeparatedStringsConverter() List<String>? include,
    int? limit,
    int? offset,
  }) = _ReportQuery;

  factory ReportQuery.fromJson(Map<String, dynamic> json) =>
      _$ReportQueryFromJson(json);
}
