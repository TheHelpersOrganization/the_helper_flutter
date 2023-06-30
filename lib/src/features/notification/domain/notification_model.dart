import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';
import 'package:the_helper/src/features/organization/domain/organization.dart';
import 'package:the_helper/src/features/report/domain/report_model.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

enum NotificationType {
  system,
  activity,
  shift,
  organization,
  report,
  other,
}

@freezed
class NotificationModel with _$NotificationModel {
  @JsonSerializable(includeIfNull: false)
  factory NotificationModel({
    required int id,
    required int accountId,
    String? from,
    required NotificationType type,
    required String title,
    required String description,
    String? shortDescription,
    required bool read,
    int? activityId,
    Activity? activity,
    int? shiftId,
    Shift? shift,
    int? organizationId,
    Organization? organization,
    int? reportId,
    ReportModel? report,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
}
