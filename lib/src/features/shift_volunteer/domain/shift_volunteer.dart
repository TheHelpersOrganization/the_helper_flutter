import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/features/profile/domain/profile.dart';
import 'package:the_helper/src/features/shift/domain/minimal_shift.dart';

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
  @JsonSerializable(includeIfNull: false)
  factory ShiftVolunteer({
    required int id,
    required int shiftId,
    required int accountId,
    bool? checkedIn,
    bool? checkedOut,
    bool? isCheckInVerified,
    bool? isCheckOutVerified,
    bool? isCheckInOutVerifierId,
    required bool attendant,
    required double completion,
    String? reviewNote,
    int? reviewerId,
    required ShiftVolunteerStatus status,
    required DateTime createdAt,
    required DateTime updatedAt,
    Profile? profile,
    MinimalShift? shift,
  }) = _ShiftVolunteer;

  factory ShiftVolunteer.fromJson(Map<String, dynamic> json) =>
      _$ShiftVolunteerFromJson(json);
}
