import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_me.freezed.dart';
part 'activity_me.g.dart';

@freezed
class ActivityMe with _$ActivityMe {
  @JsonSerializable(includeIfNull: false)
  factory ActivityMe({
    bool? isManager,
    bool? isShiftManager,
    int? shiftManagerCount,
  }) = _ActivityMe;

  factory ActivityMe.fromJson(Map<String, dynamic> json) =>
      _$ActivityMeFromJson(json);
}
