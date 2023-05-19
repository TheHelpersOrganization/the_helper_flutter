import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_include.freezed.dart';
part 'activity_include.g.dart';

@freezed
class ActivityInclude with _$ActivityInclude {
  @JsonSerializable(includeIfNull: false)
  factory ActivityInclude({
    @Default(false) bool organization,
    @Default(false) bool volunteers,
  }) = _ActivityInclude;

  factory ActivityInclude.fromJson(Map<String, dynamic> json) =>
      _$ActivityIncludeFromJson(json);
}
