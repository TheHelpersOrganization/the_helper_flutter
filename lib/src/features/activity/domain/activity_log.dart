import 'package:freezed_annotation/freezed_annotation.dart';

import 'activity_count.dart';

part 'activity_log.freezed.dart';
part 'activity_log.g.dart';

@freezed
class ActivityLog with _$ActivityLog {
  @JsonSerializable(includeIfNull: false)
  factory ActivityLog({
    required int total,
    @Default([]) List<ActivityCount> monthly,
  }) = _ActivityLog;

  factory ActivityLog.fromJson(Map<String, dynamic> json) =>
      _$ActivityLogFromJson(json);
}
