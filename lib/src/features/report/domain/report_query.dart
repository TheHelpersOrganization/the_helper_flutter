import 'package:freezed_annotation/freezed_annotation.dart';
// import 'package:the_helper/src/features/report/domain/report_status.dart';

import '../../../common/converter/comma_separated_strings_converter.dart';

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

class ReportStatus {
  static const pending = 'pending';
  static const cancelled = 'cancelled';
  static const reviewing = 'reviewing';
  static const rejected = 'rejected';
  static const completed = 'completed';
}

class ReportType {
  static const account = 'account';
  static const organization = 'organization';
  static const activity = 'activity';
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
