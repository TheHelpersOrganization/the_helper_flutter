import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_shift_skill.freezed.dart';
part 'create_shift_skill.g.dart';

@freezed
class CreateShiftSkill with _$CreateShiftSkill {
  const factory CreateShiftSkill({
    required int skillId,
    double? hours,
  }) = _CreateShiftSkill;

  factory CreateShiftSkill.fromJson(Map<String, dynamic> json) =>
      _$CreateShiftSkillFromJson(json);
}
