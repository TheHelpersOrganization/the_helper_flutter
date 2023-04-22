import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/features/location/domain/location.dart';
import 'package:the_helper/src/features/contact/domain/contact.dart';
import 'shift_skill.dart';
import 'shift_volunteer.dart';
import 'shift_manager.dart';

part 'shift.freezed.dart';
part 'shift.g.dart';

@freezed
class Shift with _$Shift {
  const factory Shift({
    required int id,
    required int activityId,
    String? name,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    int? numberOfParticipants,
    List<Location>? locations,
    List<Contact>? contacts,
    List<ShiftSkill>? shiftSkills,
    List<ShiftVolunteer>? shiftVolunteers,
    List<ShiftManager>? shiftManagers,
  }) = _Shift;
  factory Shift.fromJson(Map<String, dynamic> json) => _$ShiftFromJson(json);
}
