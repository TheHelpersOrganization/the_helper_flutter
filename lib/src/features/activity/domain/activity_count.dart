import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_count.freezed.dart';
part 'activity_count.g.dart';

@freezed
class ActivityCount with _$ActivityCount {
  @JsonSerializable(includeIfNull: false)
  factory ActivityCount({
    required int month,
    required int year,
    @Default(0) int count,
  }) = _ActivityCount;

  factory ActivityCount.fromJson(Map<String, dynamic> json) =>
      _$ActivityCountFromJson(json);
}
