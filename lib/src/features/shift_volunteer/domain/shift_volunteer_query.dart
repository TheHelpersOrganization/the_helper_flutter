import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/common/converter/converter.dart';
import 'package:the_helper/src/features/shift_volunteer/domain/shift_volunteer.dart';

part 'shift_volunteer_query.freezed.dart';
part 'shift_volunteer_query.g.dart';

class ShiftVolunteerQueryInclude {
  static const String shift = 'shift';
  static const String profile = 'profile';
}

@freezed
class ShiftVolunteerQuery with _$ShiftVolunteerQuery {
  @JsonSerializable(includeIfNull: false)
  factory ShiftVolunteerQuery({
    @CommaSeparatedIntsConverter() List<int>? id,
    int? shiftId,
    int? activityId,
    bool? mine,
    ShiftVolunteerStatus? status,
    int? limit,
    int? offset,
    @CommaSeparatedStringsConverter() List<String>? include,
  }) = _ShiftVolunteerQuery;

  factory ShiftVolunteerQuery.fromJson(Map<String, dynamic> json) =>
      _$ShiftVolunteerQueryFromJson(json);
}
