import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/features/contact/domain/contact.dart';
import 'package:the_helper/src/features/location/domain/location.dart';
import 'package:the_helper/src/features/shift/domain/create_shift_manager.dart';
import 'package:the_helper/src/features/shift/domain/create_shift_skill.dart';

part 'update_shift.freezed.dart';
part 'update_shift.g.dart';

@freezed
class UpdateShift with _$UpdateShift {
  @JsonSerializable(includeIfNull: false)
  const factory UpdateShift({
    String? name,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    int? numberOfParticipants,
    List<Location>? locations,
    List<int>? contacts,
    List<CreateShiftSkill>? shiftSkills,
    List<CreateShiftManager>? shiftManagers,
  }) = _UpdateShift;

  factory UpdateShift.fromJson(Map<String, dynamic> json) =>
      _$UpdateShiftFromJson(json);
}
