import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/features/activity/domain/activity.dart';
import 'package:the_helper/src/features/contact/domain/contact.dart';
import 'package:the_helper/src/features/location/domain/location.dart';
import 'package:the_helper/src/features/shift/domain/overlapping_shift.dart';
import 'package:the_helper/src/features/shift/domain/shift_me.dart';
import 'package:the_helper/src/features/shift/domain/shift_volunteer.dart';
import 'package:the_helper/src/features/shift/domain/traveling_constrained_shift.dart';

import 'shift_manager.dart';
import 'shift_skill.dart';

part 'shift.freezed.dart';
part 'shift.g.dart';

enum ShiftStatus {
  pending,
  ongoing,
  completed,
}

@freezed
class Shift with _$Shift {
  const factory Shift({
    required int id,
    required int activityId,
    required String name,
    String? description,
    ShiftStatus? status,
    required DateTime startTime,
    required DateTime endTime,
    int? numberOfParticipants,
    required int joinedParticipants,
    List<Location>? locations,
    List<Contact>? contacts,
    List<ShiftSkill>? shiftSkills,
    List<ShiftVolunteer>? shiftVolunteers,
    List<ShiftManager>? shiftManagers,
    ShiftVolunteer? myShiftVolunteer,
    ShiftMe? me,
    Activity? activity,
    List<OverlappingShift>? overlaps,
    List<TravelingConstrainedShift>? travelingConstrainedShifts,
  }) = _Shift;

  factory Shift.fromJson(Map<String, dynamic> json) => _$ShiftFromJson(json);
}

extension ShiftX on Shift {
  get isFull =>
      numberOfParticipants != null &&
      joinedParticipants >= numberOfParticipants!;
}
