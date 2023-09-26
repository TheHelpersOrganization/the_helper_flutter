import 'package:json_annotation/json_annotation.dart';
import 'package:the_helper/src/features/change_role/domain/user_role.dart';

class CommaSeparatedRolesConverter
    implements JsonConverter<List<Role>?, String?> {
  const CommaSeparatedRolesConverter();

  @override
  fromJson(String? json) {
    if (json == null) {
      return null;
    }
    return json
        .split(',')
        .map(
            (e) => Role.values.firstWhere((element) => element.toString() == e))
        .toList();
  }

  @override
  toJson(List<Role>? object) {
    if (object == null) {
      return null;
    }
    return object.map((e) => e.name).join(',');
  }
}
