import 'package:freezed_annotation/freezed_annotation.dart';

part 'report_yearly_count.freezed.dart';
part 'report_yearly_count.g.dart';

@freezed
class ReportYearlyCount with _$ReportYearlyCount {
  @JsonSerializable(includeIfNull: false)
  factory ReportYearlyCount({
    required int year,
    @Default(0) int count,
  }) = _ReportYearlyCount;

  factory ReportYearlyCount.fromJson(Map<String, dynamic> json) =>
      _$ReportYearlyCountFromJson(json);
}
