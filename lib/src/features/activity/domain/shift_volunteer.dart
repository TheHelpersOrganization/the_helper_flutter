import 'package:freezed_annotation/freezed_annotation.dart';

part 'shift_volunteer.freezed.dart';
part 'shift_volunteer.g.dart';

@freezed
class ShiftVolunteer with _$ShiftVolunteer {
  const factory ShiftVolunteer({
    required int shiftId,
    required int accountId,
    bool? attendant,
    double? completion,
    String? status,
  }) = _ShiftVolunteer;
  factory ShiftVolunteer.fromJson(Map<String, dynamic> json) => _$ShiftVolunteerFromJson(json);
}