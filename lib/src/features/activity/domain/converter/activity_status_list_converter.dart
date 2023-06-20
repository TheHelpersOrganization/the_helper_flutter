import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/features/activity/domain/activity_status.dart';

class ActivityStatusListConverter
    implements JsonConverter<List<ActivityStatus>?, String?> {
  const ActivityStatusListConverter();

  @override
  List<ActivityStatus>? fromJson(String? json) {
    if (json == null) {
      return null;
    }
    return json
        .split(',')
        .map(
          (e) => ActivityStatus.values.firstWhere(
            (element) => element.name == e,
          ),
        )
        .toList();
  }

  @override
  String? toJson(List<ActivityStatus>? object) {
    if (object == null) {
      return null;
    }
    return object.map((e) => e.name).join(',');
  }
}
