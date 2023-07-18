import 'package:freezed_annotation/freezed_annotation.dart';

part 'delete_notifications.freezed.dart';
part 'delete_notifications.g.dart';

@freezed
class DeleteNotifications with _$DeleteNotifications {
  @JsonSerializable(includeIfNull: false)
  factory DeleteNotifications({
    required List<int> id,
  }) = _DeleteNotifications;

  factory DeleteNotifications.fromJson(Map<String, dynamic> json) =>
      _$DeleteNotificationsFromJson(json);
}
