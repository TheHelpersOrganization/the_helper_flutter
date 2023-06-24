import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/common/converter/converter.dart';
import 'package:the_helper/src/features/shift/domain/converter/converter.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';
import 'package:the_helper/src/features/shift/domain/shift_volunteer.dart';

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
    @CommaSeparatedShiftStatusConverter() List<ShiftStatus>? status,
    @CommaSeparatedShiftVolunteerStatusConverter()
    List<ShiftVolunteerStatus>? myJoinStatus,
    String? name,
    bool? isShiftManager,
    @CommaSeparatedStringsConverter() List<String>? include,
    @CommaSeparatedStringsConverter() List<String>? sort,
    int? limit,
    int? offset,
  }) = _ShiftQuery;

  factory ShiftQuery.fromJson(Map<String, dynamic> json) =>
      _$ShiftQueryFromJson(json);
}
