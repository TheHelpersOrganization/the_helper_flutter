import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/features/shift/domain/shift_volunteer.dart';

part 'list_shift_volunteers.freezed.dart';
part 'list_shift_volunteers.g.dart';

@freezed
class ListShiftVolunteers with _$ListShiftVolunteers {
  const factory ListShiftVolunteers({
    required Map<String, dynamic> meta,
    required List<ShiftVolunteer?> data,
  }) = _ListShiftVolunteers;
  factory ListShiftVolunteers.fromJson(Map<String, dynamic> json) => _$ListShiftVolunteersFromJson(json);
}