import 'package:freezed_annotation/freezed_annotation.dart';

part 'attendance.freezed.dart';
part 'attendance.g.dart';

@freezed
class Attendance with _$Attendance{
  @JsonSerializable(includeIfNull: false)
  factory Attendance({
    int? id,
    required bool checkedIn,
    required bool checkedOut,
  }) = _Attendance;
  factory Attendance.fromJson(Map<String, dynamic> json) => _$AttendanceFromJson(json);
}
