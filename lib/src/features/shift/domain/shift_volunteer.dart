import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/features/profile/domain/profile.dart';

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
  @JsonSerializable(includeIfNull: true)
  const factory ShiftVolunteer({
    required int shiftId,
    required int accountId,
    @Default(false) bool attendant,
    @Default(0) double completion,
    required ShiftVolunteerStatus status,
    Profile? profile,
  }) = _ShiftVolunteer;

  factory ShiftVolunteer.fromJson(Map<String, dynamic> json) =>
      _$ShiftVolunteerFromJson(json);
}
