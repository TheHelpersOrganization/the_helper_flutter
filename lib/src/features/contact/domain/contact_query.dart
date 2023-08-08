import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact_query.freezed.dart';
part 'contact_query.g.dart';

@freezed
class ContactQuery with _$ContactQuery {
  @JsonSerializable(includeIfNull: false)
  const factory ContactQuery({
    int? accountId,
    int? organizationId,
  }) = _ContactQuery;

  factory ContactQuery.fromJson(Map<String, dynamic> json) =>
      _$ContactQueryFromJson(json);
}
