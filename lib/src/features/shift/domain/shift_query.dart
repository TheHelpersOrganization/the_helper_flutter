import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/common/converter/converter.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';
import 'package:the_helper/src/features/shift_volunteer/domain/shift_volunteer.dart';

part 'shift_query.freezed.dart';
part 'shift_query.g.dart';

class ShiftQueryInclude {
  static const shiftSkill = 'shiftSkill';
  static const shiftManager = 'shiftManager';
  static const shiftVolunteer = 'shiftVolunteer';
  static const myShiftVolunteer = 'myShiftVolunteer';
  static const activity = 'activity';
}

class ShiftQuerySort {
  static const startTimeAsc = 'startTime';
  static const startTimeDesc = '-startTime';
  static const endTimeAsc = 'endTime';
  static const endTimeDesc = '-endTime';
}

@freezed
class ShiftQuery with _$ShiftQuery {
  @JsonSerializable(includeIfNull: false)
  const factory ShiftQuery({
    @CommaSeparatedIntsConverter() List<int>? id,
    int? activityId,
    ShiftStatus? status,
    @CommaSeparatedShiftVolunteerStatusConverter()
    List<ShiftVolunteerStatus>? myJoinStatus,
    String? name,
    bool? isShiftManager,
    @CommaSeparatedStringsConverter() List<String>? include,
    @CommaSeparatedStringsConverter() List<String>? sort,
  }) = _ShiftQuery;

  factory ShiftQuery.fromJson(Map<String, dynamic> json) =>
      _$ShiftQueryFromJson(json);
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
