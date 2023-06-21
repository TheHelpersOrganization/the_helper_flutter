import 'package:freezed_annotation/freezed_annotation.dart';

part 'shift_me.freezed.dart';
part 'shift_me.g.dart';

@freezed
class ShiftMe with _$ShiftMe {
  @JsonSerializable(includeIfNull: false)
  const factory ShiftMe({
    bool? isShiftManager,
  }) = _ShiftMe;

  factory ShiftMe.fromJson(Map<String, dynamic> json) =>
      _$ShiftMeFromJson(json);
}
