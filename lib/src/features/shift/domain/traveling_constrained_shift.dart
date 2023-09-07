import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';

part 'traveling_constrained_shift.freezed.dart';
part 'traveling_constrained_shift.g.dart';

@freezed
class TravelingConstrainedShift with _$TravelingConstrainedShift {
  const factory TravelingConstrainedShift({
    required int id,
    required int activityId,
    required String name,
    String? description,
    ShiftStatus? status,
    required DateTime startTime,
    required DateTime endTime,
    required double distanceInMeters,
    required double distanceInKilometers,
    required double durationInSeconds,
    required double durationInHours,
    required double speedInMetersPerSecond,
    required double speedInKilometersPerHour,
  }) = _TravelingConstrainedShift;

  factory TravelingConstrainedShift.fromJson(Map<String, dynamic> json) =>
      _$TravelingConstrainedShiftFromJson(json);
}
