import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/common/converter/comma_separated_ints_converter.dart';

part 'contact_query.freezed.dart';
part 'contact_query.g.dart';

@freezed
class ContactQuery with _$ContactQuery {
  @JsonSerializable(includeIfNull: false)
  const factory ContactQuery({
    @CommaSeparatedIntsConverter() List<int>? id,
    @CommaSeparatedIntsConverter() List<int>? excludeId,
    int? accountId,
    int? organizationId,
    String? search,
    int? limit,
    int? offset,
  }) = _ContactQuery;

  factory ContactQuery.fromJson(Map<String, dynamic> json) =>
      _$ContactQueryFromJson(json);
}
