import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/features/contact/domain/contact.dart';
import 'package:the_helper/src/features/location/domain/location.dart';

import 'shift_manager.dart';
import 'shift_skill.dart';
import 'shift_volunteer.dart';

part 'shift.freezed.dart';
part 'shift.g.dart';

@freezed
class Shift with _$Shift {
  const factory Shift({
    required int id,
    required int activityId,
    required String name,
    String? description,
    required DateTime startTime,
    required DateTime endTime,
    int? numberOfParticipants,
    required int joinedParticipants,
    List<Location>? locations,
    List<Contact>? contacts,
    List<ShiftSkill>? shiftSkills,
    List<ShiftVolunteer>? shiftVolunteers,
    List<ShiftManager>? shiftManagers,
  }) = _Shift;

  factory Shift.fromJson(Map<String, dynamic> json) => _$ShiftFromJson(json);
}
