import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/features/profile/domain/profile.dart';

part 'activity_volunteer.freezed.dart';
part 'activity_volunteer.g.dart';

@freezed
class ActivityVolunteer with _$ActivityVolunteer {
  @JsonSerializable(includeIfNull: false)
  factory ActivityVolunteer({
    required int shiftId,
    required int accountId,
    required bool attendant,
    required double completion,
    Profile? profile,
  }) = _ActivityVolunteer;

  factory ActivityVolunteer.fromJson(Map<String, dynamic> json) =>
      _$ActivityVolunteerFromJson(json);
}
