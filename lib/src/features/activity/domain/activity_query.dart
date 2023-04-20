import 'package:freezed_annotation/freezed_annotation.dart';

part 'activity_query.freezed.dart';
part 'activity_query.g.dart';

@freezed
class ActivityQuery with _$ActivityQuery {
  @JsonSerializable(includeIfNull: false)
  factory ActivityQuery({
    String? n,
    List<int>? sk,
    List<int>? org,
    DateTime? st,
    DateTime? et,
    List<int>? at,
    String? lc,
    String? rg,
    String? ct,
    String? av,
    int? limit,
    int? offset,
  }) = _ActivityQuery;

  factory ActivityQuery.fromJson(Map<String, dynamic> json) =>
      _$ActivityQueryFromJson(json);
}
