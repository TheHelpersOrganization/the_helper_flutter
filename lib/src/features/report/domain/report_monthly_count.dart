import 'package:freezed_annotation/freezed_annotation.dart';

part 'report_monthly_count.freezed.dart';
part 'report_monthly_count.g.dart';

@freezed
class ReportMonthlyCount with _$ReportMonthlyCount {
  @JsonSerializable(includeIfNull: false)
  factory ReportMonthlyCount({
    required int month,
    required int year,
    @Default(0) int count,
  }) = _ReportMonthlyCount;

  factory ReportMonthlyCount.fromJson(Map<String, dynamic> json) =>
      _$ReportMonthlyCountFromJson(json);
}
