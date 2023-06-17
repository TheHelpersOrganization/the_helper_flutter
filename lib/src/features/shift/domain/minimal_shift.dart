import 'package:freezed_annotation/freezed_annotation.dart';

part 'minimal_shift.freezed.dart';
part 'minimal_shift.g.dart';

@freezed
class MinimalShift with _$MinimalShift {
  const factory MinimalShift({
    required int id,
    required int activityId,
    required String name,
    String? description,
    required DateTime startTime,
    required DateTime endTime,
    int? numberOfParticipants,
  }) = _MinimalShift;

  factory MinimalShift.fromJson(Map<String, dynamic> json) =>
      _$MinimalShiftFromJson(json);
}
