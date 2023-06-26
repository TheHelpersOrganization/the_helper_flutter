import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/features/notification/domain/notification_model.dart';

class NotificationTypeListConverter
    extends JsonConverter<List<NotificationType>?, String?> {
  const NotificationTypeListConverter();

  @override
  List<NotificationType>? fromJson(String? json) {
    return json
        ?.split(',')
        .map(
          (e) => NotificationType.values.firstWhere(
            (element) => element.name == e,
          ),
        )
        .toList();
  }

  @override
  String? toJson(List<NotificationType>? object) {
    return object?.map((e) => e.name).join(',');
  }
}
