import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/common/domain/skill.dart';

part 'shift_skill.freezed.dart';
part 'shift_skill.g.dart';

@freezed
class ShiftSkill with _$ShiftSkill {
  const factory ShiftSkill({
    int? hours,
    Skill? skill,
  }) = _ShiftSkill;
  factory ShiftSkill.fromJson(Map<String, dynamic> json) =>
      _$ShiftSkillFromJson(json);
}
