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
  left,
}

@freezed
class ShiftVolunteer with _$ShiftVolunteer {
  @JsonSerializable(includeIfNull: false)
  const factory ShiftVolunteer({
    required int id,
    int? activityId,
    required int shiftId,
    required int accountId,
    bool? checkedIn,
    DateTime? checkInAt,
    DateTime? checkOutAt,
    bool? checkedOut,
    bool? isCheckInVerified,
    bool? isCheckOutVerified,
    int? checkInOutVerifierId,
    required bool attendant,
    @Default(0) double completion,
    String? reviewNote,
    int? reviewerId,
    required ShiftVolunteerStatus status,
    bool? meetSkillRequirements,
    int? shiftRating,
    String? shiftRatingComment,
    required DateTime createdAt,
    required DateTime updatedAt,
    Profile? profile,
    MinimalShift? shift,
    bool? hasOverlappingShift,
    bool? hasTravelingConstrainedShift,
  }) = _ShiftVolunteer;

  factory ShiftVolunteer.fromJson(Map<String, dynamic> json) =>
      _$ShiftVolunteerFromJson(json);
}
