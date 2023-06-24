import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';
import 'package:the_helper/src/features/shift/domain/shift_volunteer.dart';

class CommaSeparatedShiftStatusConverter
    implements JsonConverter<List<ShiftStatus>?, String?> {
  const CommaSeparatedShiftStatusConverter();

  @override
  fromJson(String? json) {
    if (json == null) {
      return null;
    }
    List<String> parts = json.split(',');
    return ShiftStatus.values.where((e) => parts.contains(e.name)).toList();
  }

  @override
  toJson(List<ShiftStatus>? object) {
    if (object == null) {
      return null;
    }
    return object.map((e) => e.name).join(',');
  }
}

class CommaSeparatedShiftVolunteerStatusConverter
    implements JsonConverter<List<ShiftVolunteerStatus>?, String?> {
  const CommaSeparatedShiftVolunteerStatusConverter();

  @override
  fromJson(String? json) {
    if (json == null) {
      return null;
    }
    List<String> parts = json.split(',');
    return ShiftVolunteerStatus.values
        .where((e) => parts.contains(e.name))
        .toList();
  }

  @override
  toJson(List<ShiftVolunteerStatus>? object) {
    if (object == null) {
      return null;
    }
    return object.map((e) => e.name).join(',');
  }
}
