import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/features/shift/domain/shift_volunteer.dart';

part 'shift_volunteer_arg.freezed.dart';

@freezed
class ShiftVolunteerArg with _$ShiftVolunteerArg {
  // final int shiftId;
  // final List<ShiftVolunteerStatus> status;

  const factory ShiftVolunteerArg({
    required int shiftId,
    required List<ShiftVolunteerStatus> status,
  }) = _ShiftVolunteerArg;
}
