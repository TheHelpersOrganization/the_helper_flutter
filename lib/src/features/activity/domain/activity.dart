import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/features/activity/domain/activity_volunteer.dart';
import 'package:the_helper/src/features/location/domain/location.dart';
import 'package:the_helper/src/features/organization/domain/organization.dart';

part 'activity.freezed.dart';
part 'activity.g.dart';

@freezed
class Activity with _$Activity {
  factory Activity({
    int? id,
    String? name,
    String? description,
    int? thumbnail,
    int? organizationId,
    List<int>? activityTypeIds,
    List<int>? activityManagerIds,
    DateTime? startTime,
    DateTime? endTime,
    Location? location,
    int? maxParticipants,
    int? joinedParticipants,
    Organization? organization,
    List<ActivityVolunteer>? volunteers,
  }) = _Activity;

  factory Activity.fromJson(Map<String, dynamic> json) =>
      _$ActivityFromJson(json);
}
