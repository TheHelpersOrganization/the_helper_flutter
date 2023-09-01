import 'package:freezed_annotation/freezed_annotation.dart';

import 'activity_status.dart';
import 'converter/activity_status_list_converter.dart';

part 'activity_log_query.freezed.dart';
part 'activity_log_query.g.dart';

@freezed
class ActivityLogQuery with _$ActivityLogQuery {
  @JsonSerializable(includeIfNull: false)
  factory ActivityLogQuery({
    int? startTime,
    int? endTime,
    bool? isDisabled,
    @ActivityStatusListConverter() List<ActivityStatus>? status,
  }) = _ActivityLogQuery;

  factory ActivityLogQuery.fromJson(Map<String, dynamic> json) =>
      _$ActivityLogQueryFromJson(json);
}
