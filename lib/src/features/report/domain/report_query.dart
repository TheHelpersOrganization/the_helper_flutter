import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/common/converter/comma_separated_datetimes_converter.dart';

import '../../../common/converter/comma_separated_strings_converter.dart';

part 'report_query.freezed.dart';
part 'report_query.g.dart';

class ReportQuerySort {
  static const startTimeAsc = 'startTime';
  static const startTimeDesc = '-startTime';
  static const endTimeAsc = 'endTime';
  static const endTimeDesc = '-endTime';
}

class ReportQueryInclude {
  static const reporter = 'reporter';
  static const message = 'message';
}

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
    @CommaSeparatedStringsConverter() List<String>? include,
    @CommaSeparatedStringsConverter() List<String>? sort,
    int? limit,
    int? offset,
  }) = _ReportQuery;

  factory ReportQuery.fromJson(Map<String, dynamic> json) =>
      _$ReportQueryFromJson(json);
}
