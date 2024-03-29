import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/features/contact/domain/contact.dart';
import 'package:the_helper/src/features/location/domain/location.dart';
import 'package:the_helper/src/features/shift/domain/create_shift_manager.dart';
import 'package:the_helper/src/features/shift/domain/create_shift_skill.dart';

part 'create_shift.freezed.dart';
part 'create_shift.g.dart';

@freezed
class CreateShift with _$CreateShift {
  @JsonSerializable(includeIfNull: false)
  const factory CreateShift({
    required int activityId,
    required String name,
    String? description,
    required DateTime startTime,
    required DateTime endTime,
    int? numberOfParticipants,
    List<Location>? locations,
    List<int>? contacts,
    List<CreateShiftSkill>? shiftSkills,
    List<CreateShiftManager>? shiftManagers,
  }) = _CreateShift;

  factory CreateShift.fromJson(Map<String, dynamic> json) =>
      _$CreateShiftFromJson(json);
}
