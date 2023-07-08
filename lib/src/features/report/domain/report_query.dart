import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/common/converter/comma_separated_datetimes_converter.dart';
import 'package:the_helper/src/features/report/domain/report_status.dart';

import '../../../common/converter/comma_separated_strings_converter.dart';
import 'report_type.dart';

part 'report_query.freezed.dart';
part 'report_query.g.dart';

class ReportQuerySort {
  static const createdTimeAsc = 'createdAt';
  static const createdTimeDesc = '-createdAt';
  static const updatedTimeAsc = 'updatedAt';
  static const updatedTimeDesc = '-updatedAt';
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
    ReportType? type,
    ReportStatus? status,
    @CommaSeparatedStringsConverter() List<String>? include,
    @Default([ReportQuerySort.updatedTimeDesc]) @CommaSeparatedStringsConverter() List<String>? sort,
    int? limit,
    int? offset,
  }) = _ReportQuery;

  factory ReportQuery.fromJson(Map<String, dynamic> json) =>
      _$ReportQueryFromJson(json);
}
