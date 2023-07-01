import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'account_data.dart';
import 'activity_data.dart';
import 'organization_data.dart';
import 'report_message.dart';

part 'admin_report.freezed.dart';
part 'admin_report.g.dart';

@freezed
class AdminReportModel with _$AdminReportModel {
  factory AdminReportModel({
    int? id,
    required String type,
    required String status,
    required String title,
    required int reporterId,
    AccountData? reporter,
    int? reviewerId,
    required DateTime createdAt,
    required DateTime updatedAt,
    required List<ReportMessageModel> messages,
    AccountData? reportedAccount,
    ActivityData? reportedActivity,
    OrganizationData? reportedOrganization
  }) = _AdminReportModel;

  factory AdminReportModel.fromJson(Map<String, dynamic> json) =>
      _$AdminReportModelFromJson(json);
}
