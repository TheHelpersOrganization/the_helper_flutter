import 'package:freezed_annotation/freezed_annotation.dart';

part 'organization_query.freezed.dart';
part 'organization_query.g.dart';

@freezed
class OrganizationQuery with _$OrganizationQuery {
  @JsonSerializable(includeIfNull: false)
  const factory OrganizationQuery({
    String? name,
  }) = _OrganizationQuery;

  factory OrganizationQuery.fromJson(Map<String, dynamic> json) =>
      _$OrganizationQueryFromJson(json);
}
