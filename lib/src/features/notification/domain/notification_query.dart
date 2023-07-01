import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/common/converter/converter.dart';
import 'package:the_helper/src/features/notification/domain/converter/notification_type_list_converter.dart';
import 'package:the_helper/src/features/notification/domain/notification_model.dart';

part 'notification_query.freezed.dart';
part 'notification_query.g.dart';

class NotificationQuerySort {
  static const createdAtAsc = 'createdAt';
  static const createdAtDesc = '-createdAt';
}

class NotificationQueryInclude {
  static const data = 'data';
}

@freezed
class NotificationQuery with _$NotificationQuery {
  @JsonSerializable(includeIfNull: false)
  factory NotificationQuery({
    @CommaSeparatedIntsConverter() List<int>? id,
    String? name,
    bool? read,
    @NotificationTypeListConverter() List<NotificationType>? type,
    int? limit,
    int? offset,
    @CommaSeparatedStringsConverter() List<String>? sort,
    String? include,
  }) = _NotificationQuery;

  factory NotificationQuery.fromJson(Map<String, dynamic> json) =>
      _$NotificationQueryFromJson(json);
}
