import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/common/converter/converter.dart';

part 'shift_query.freezed.dart';
part 'shift_query.g.dart';

class ShiftQueryInclude {
  static const shiftSkill = 'shiftSkill';
  static const shiftManager = 'shiftManager';
  static const shiftVolunteer = 'shiftVolunteer';
}

@freezed
class ShiftQuery with _$ShiftQuery {
  @JsonSerializable(includeIfNull: false)
  const factory ShiftQuery({
    @CommaSeparatedIntsConverter() List<int>? id,
    int? activityId,
    @CommaSeparatedStringsConverter() List<String>? include,
  }) = _ShiftQuery;

  factory ShiftQuery.fromJson(Map<String, dynamic> json) =>
      _$ShiftQueryFromJson(json);
}
