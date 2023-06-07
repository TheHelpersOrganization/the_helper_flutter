import 'package:json_annotation/json_annotation.dart';

class CommaSeparatedStringsConverter
    implements JsonConverter<List<String>?, String?> {
  const CommaSeparatedStringsConverter();

  @override
  fromJson(String? json) {
    if (json == null) {
      return null;
    }
    return json.split(',');
  }

  @override
  toJson(List<String>? object) {
    if (object == null) {
      return null;
    }
    return object.join(',');
  }
}
