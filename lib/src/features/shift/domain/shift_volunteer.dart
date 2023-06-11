import 'package:freezed_annotation/freezed_annotation.dart';

part 'shift_volunteer.freezed.dart';
part 'shift_volunteer.g.dart';

enum ShiftVolunteerStatus {
  pending,
  cancelled,
  approved,
  rejected,
  removed,
  leaved,
}

@freezed
class ShiftVolunteer with _$ShiftVolunteer {
  const factory ShiftVolunteer({
    required int shiftId,
    required int accountId,
    @Default(false) bool attendant,
    @Default(0) double completion,
    required ShiftVolunteerStatus status,
  }) = _ShiftVolunteer;

  factory ShiftVolunteer.fromJson(Map<String, dynamic> json) =>
      _$ShiftVolunteerFromJson(json);
}
