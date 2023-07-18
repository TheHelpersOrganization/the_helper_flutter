import 'package:freezed_annotation/freezed_annotation.dart';

part 'mark_notifications_as_read.freezed.dart';
part 'mark_notifications_as_read.g.dart';

@freezed
class MarkNotificationsAsRead with _$MarkNotificationsAsRead {
  @JsonSerializable(includeIfNull: false)
  factory MarkNotificationsAsRead({
    required List<int> id,
  }) = _MarkNotificationsAsRead;

  factory MarkNotificationsAsRead.fromJson(Map<String, dynamic> json) =>
      _$MarkNotificationsAsReadFromJson(json);
}
