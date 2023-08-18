import 'package:freezed_annotation/freezed_annotation.dart';

part 'rate_shift.freezed.dart';
part 'rate_shift.g.dart';

@freezed
class RateShift with _$RateShift {
  @JsonSerializable(includeIfNull: false)
  const factory RateShift({
    required int rating,
    String? comment,
  }) = _RateShift;

  factory RateShift.fromJson(Map<String, dynamic> json) =>
      _$RateShiftFromJson(json);
}
