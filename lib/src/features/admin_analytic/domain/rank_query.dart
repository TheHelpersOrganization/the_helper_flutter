import 'package:freezed_annotation/freezed_annotation.dart';

part 'rank_query.g.dart';
part 'rank_query.freezed.dart';

@freezed
class RankQuery with _$RankQuery {
  @JsonSerializable(includeIfNull: false)
  const factory RankQuery({
    @Default(5) int limit,
  }) = _RankQuery;

  factory RankQuery.fromJson(Map<String, dynamic> json) =>
      _$RankQueryFromJson(json);
}
