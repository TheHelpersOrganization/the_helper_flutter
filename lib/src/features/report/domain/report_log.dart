import 'package:freezed_annotation/freezed_annotation.dart';

import 'report_monthly_count.dart';
import 'report_yearly_count.dart';

part 'report_log.freezed.dart';
part 'report_log.g.dart';

@freezed
class ReportLog with _$ReportLog {
  @JsonSerializable(includeIfNull: false)
  factory ReportLog({
    required int total,
    @Default([]) List<ReportMonthlyCount> monthly,
    @Default([]) List<ReportYearlyCount> yearly,
  }) = _ReportLog;

  factory ReportLog.fromJson(Map<String, dynamic> json) =>
      _$ReportLogFromJson(json);
}
