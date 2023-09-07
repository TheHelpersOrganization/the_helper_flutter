import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/common/converter/converter.dart';
import 'package:the_helper/src/features/shift/domain/converter/converter.dart';
import 'package:the_helper/src/features/shift/domain/shift_volunteer.dart';

part 'shift_volunteer_query.freezed.dart';
part 'shift_volunteer_query.g.dart';

class ShiftVolunteerQueryInclude {
  static const String shift = 'shift';
  static const String profile = 'profile';
  static const String overlappingCheck = 'overlappingCheck';
  static const String travelingConstrainedCheck = 'travelingConstrainedCheck';
}

@freezed
class ShiftVolunteerQuery with _$ShiftVolunteerQuery {
  @JsonSerializable(includeIfNull: false)
  factory ShiftVolunteerQuery({
    @CommaSeparatedIntsConverter() List<int>? id,
    int? shiftId,
    int? activityId,
    bool? mine,
    String? name,
    @CommaSeparatedShiftVolunteerStatusConverter()
    List<ShiftVolunteerStatus>? status,
    int? limit,
    int? offset,
    bool? active,
    @CommaSeparatedStringsConverter() List<String>? include,
  }) = _ShiftVolunteerQuery;

  factory ShiftVolunteerQuery.fromJson(Map<String, dynamic> json) =>
      _$ShiftVolunteerQueryFromJson(json);
}
