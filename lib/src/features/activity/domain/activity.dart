import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/features/activity/domain/activity_me.dart';
import 'package:the_helper/src/features/contact/domain/contact.dart';
import 'package:the_helper/src/features/location/domain/location.dart';
import 'package:the_helper/src/features/organization/domain/organization.dart';
import 'package:the_helper/src/features/shift/domain/shift_volunteer.dart';
import 'package:the_helper/src/features/skill/domain/skill.dart';

import 'activity_status.dart';

part 'activity.freezed.dart';
part 'activity.g.dart';

@freezed
class Activity with _$Activity {
  @JsonSerializable(includeIfNull: false)
  factory Activity({
    int? id,
    String? name,
    bool? isDisabled,
    ActivityStatus? status,
    String? description,
    int? thumbnail,
    int? organizationId,
    List<int>? skillIds,
    List<int>? activityManagerIds,
    DateTime? startTime,
    DateTime? endTime,
    Location? location,
    List<Contact>? contacts,
    int? maxParticipants,
    int? joinedParticipants,
    Organization? organization,
    List<ShiftVolunteer>? volunteers,
    List<Skill>? skills,
    ActivityMe? me,
  }) = _Activity;

  factory Activity.fromJson(Map<String, dynamic> json) =>
      _$ActivityFromJson(json);
}
