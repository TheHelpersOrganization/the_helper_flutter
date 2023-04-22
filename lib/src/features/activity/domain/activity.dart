import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/features/location/domain/location.dart';

part 'activity.g.dart';
part 'activity.freezed.dart';

@freezed
class Activity with _$Activity {
  const factory Activity({
    required String id,
    required String name,
    String? description,
    // TODO: replace int with actual model
    int? thumbnail,
    int? organizationId,
    List<int>? activityTypeIds,
    List<int>? activityManagerIds,
    DateTime? startTime,
    DateTime? endTime,
    Location? location,
    int? maxParticipants,
    int? joinedParticipants,
  }) = _Activity;
  factory Activity.fromJson(Map<String, dynamic> json) =>
      _$ActivityFromJson(json);
}
