import 'package:freezed_annotation/freezed_annotation.dart';

part 'data_monthly_log.freezed.dart';
part 'data_monthly_log.g.dart';

@freezed
class DataMonthlyLog with _$DataMonthlyLog {
  @JsonSerializable(includeIfNull: false)
  factory DataMonthlyLog({
    required int month,
    required int year,
    @Default(0) int count,
  }) = _DataMonthlyLog;

  factory DataMonthlyLog.fromJson(Map<String, dynamic> json) =>
      _$DataMonthlyLogFromJson(json);
}
