
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/features/shift/domain/attendance.dart';

part 'list_attendance.freezed.dart';
part 'list_attendance.g.dart';

@freezed
class ListAttendance with _$ListAttendance{
  @JsonSerializable(includeIfNull: false)
  factory ListAttendance({
    required List<Attendance?> volunteers,
  }) = _ListAttendance;
  factory ListAttendance.fromJson(Map<String, dynamic> json) => _$ListAttendanceFromJson(json);
}
