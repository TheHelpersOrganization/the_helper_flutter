import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

enum NotificationType {
  system,
  activity,
  organization,
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
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
}
