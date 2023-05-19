import 'package:json_annotation/json_annotation.dart';

class CommaSeparatedDateTimesConverter
    implements JsonConverter<List<DateTime>?, String?> {
  const CommaSeparatedDateTimesConverter();

  @override
  fromJson(String? json) {
    if (json == null) {
      return null;
    }
    return json
        .split(',')
        .map((e) =>
            DateTime.fromMicrosecondsSinceEpoch(int.parse(e), isUtc: true))
        .toList();
  }

  @override
  toJson(List<DateTime>? object) {
    if (object == null) {
      return null;
    }
    return object.map((e) => e.millisecondsSinceEpoch).join(',');
  }
}
