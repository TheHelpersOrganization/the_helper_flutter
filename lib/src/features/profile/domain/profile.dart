import 'package:freezed_annotation/freezed_annotation.dart';

import '../../location/domain/location.dart';
import '../../skill/domain/skill.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

@freezed
class Profile with _$Profile {
  @JsonSerializable(includeIfNull: false)
  factory Profile({
    int? id,
    String? username,
    String? phoneNumber,
    String? firstName,
    String? lastName,
    String? gender,
    String? bio,
    DateTime? dateOfBirth,
    Location? location,
    int? avatarId,
    @Default([]) List<Skill> skills,
    @Default([]) List<Skill> interestedSkills,
  }) = _Profile;
  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
}
