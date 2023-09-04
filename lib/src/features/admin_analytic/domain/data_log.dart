import 'package:freezed_annotation/freezed_annotation.dart';

import 'data_monthly_log.dart';
import 'data_yearly_log.dart';

part 'data_log.freezed.dart';
part 'data_log.g.dart';

@freezed
class DataLog with _$DataLog {
  @JsonSerializable(includeIfNull: false)
  factory DataLog({
    required int total,
    @Default([]) List<DataMonthlyLog> monthly,
    @Default([]) List<DataYearlyLog> yearly,
  }) = _DataLog;

  factory DataLog.fromJson(Map<String, dynamic> json) =>
      _$DataLogFromJson(json);
}
