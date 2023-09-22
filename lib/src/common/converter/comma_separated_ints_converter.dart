import 'package:json_annotation/json_annotation.dart';

class CommaSeparatedIntsConverter
    implements JsonConverter<List<int>?, String?> {
  const CommaSeparatedIntsConverter();

  @override
  fromJson(String? json) {
    if (json == null) {
      return null;
    }
    return json.split(',').map((e) => int.parse(e)).toList();
  }

  @override
  toJson(List<int>? object) {
    if (object == null) {
      return null;
    }
    return object.join(',');
  }
}

class NonNullCommaSeparatedIntsConverter
    implements JsonConverter<List<int>, String> {
  const NonNullCommaSeparatedIntsConverter();

  @override
  fromJson(String json) {
    return json.split(',').map((e) => int.parse(e)).toList();
  }

  @override
  toJson(List<int> object) {
    return object.join(',');
  }
}
