import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_log_query.freezed.dart';
part 'activity_log_query.g.dart';

@freezed
class ActivityLogQuery with _$ActivityLogQuery {
  @JsonSerializable(includeIfNull: false)
  factory ActivityLogQuery({
    DateTime? startDate,
    DateTime? endDate,
  }) = _ActivityLogQuery;

  factory ActivityLogQuery.fromJson(Map<String, dynamic> json) =>
      _$ActivityLogQueryFromJson(json);
}
