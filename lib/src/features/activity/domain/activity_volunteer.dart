import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/features/profile/domain/profile.dart';

part 'activity_volunteer.freezed.dart';
part 'activity_volunteer.g.dart';

enum ActivityVolunteerStatus{
  pending, 
  cancelled, 
  approved, 
  rejected, 
  removed, 
  left
}

@freezed
class ActivityVolunteer with _$ActivityVolunteer {
  @JsonSerializable(includeIfNull: false)
  factory ActivityVolunteer({
    int? id,
    required int shiftId,
    required int accountId,
    required ActivityVolunteerStatus status,
    required bool active,
    required bool meetSkillRequirements,
    bool? checkedIn,
    DateTime? checkInAt,
    DateTime? checkOutAt,
    bool? checkedOut,
    bool? isCheckInVerified,
    bool? isCheckOutVerified,
    int? checkInOutVerifierId,
    required double completion,
    String? reviewNote,
    int? reviewerId,
    required DateTime createdAt,
    required DateTime updatedAt,
    Profile? profile,
  }) = _ActivityVolunteer;

  factory ActivityVolunteer.fromJson(Map<String, dynamic> json) =>
      _$ActivityVolunteerFromJson(json);
}
