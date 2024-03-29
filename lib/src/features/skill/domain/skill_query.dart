import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/features/account/domain/account_query.dart';

part 'skill_query.freezed.dart';
part 'skill_query.g.dart';

@freezed
class SkillQuery with _$SkillQuery {
  @JsonSerializable(includeIfNull: false)
  factory SkillQuery({
    @IntListConverter() List<int>? ids,
    String? name,
    int? limit,
    int? offset,
  }) = _SkillQuery;

  factory SkillQuery.fromJson(Map<String, dynamic> json) =>
      _$SkillQueryFromJson(json);
}
