import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';

part 'overlapping_shift.freezed.dart';
part 'overlapping_shift.g.dart';

@freezed
class OverlappingShift with _$OverlappingShift {
  const factory OverlappingShift({
    required int id,
    required int activityId,
    required String name,
    String? description,
    ShiftStatus? status,
    required DateTime startTime,
    required DateTime endTime,
  }) = _OverlappingShift;

  factory OverlappingShift.fromJson(Map<String, dynamic> json) =>
      _$OverlappingShiftFromJson(json);
}
