import 'package:freezed_annotation/freezed_annotation.dart';

part 'data_yearly_log.freezed.dart';
part 'data_yearly_log.g.dart';

@freezed
class DataYearlyLog with _$DataYearlyLog {
  @JsonSerializable(includeIfNull: false)
  factory DataYearlyLog({
    required int year,
    @Default(0) int count,
  }) = _DataYearlyLog;

  factory DataYearlyLog.fromJson(Map<String, dynamic> json) =>
      _$DataYearlyLogFromJson(json);
}
