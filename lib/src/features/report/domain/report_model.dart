import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'account_data.dart';
import 'activity_data.dart';
import 'organization_data.dart';
import 'report_message.dart';
import 'report_status.dart';
import 'report_type.dart';

part 'report_model.freezed.dart';
part 'report_model.g.dart';

@freezed
class ReportModel with _$ReportModel {
  factory ReportModel(
      {int? id,
      required ReportType type,
      required ReportStatus status,
      required String title,
      required int reporterId,
      AccountData? reporter,
      int? reviewerId,
      required DateTime createdAt,
      required DateTime updatedAt,
      List<ReportMessageModel>? messages,
      AccountData? reportedAccount,
      ActivityData? reportedActivity,
      OrganizationData? reportedOrganization}) = _ReportModel;

  factory ReportModel.fromJson(Map<String, dynamic> json) =>
      _$ReportModelFromJson(json);
}
