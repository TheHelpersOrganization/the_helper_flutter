import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/common/converter/converter.dart';

import '../../organization_member/domain/organization_member_status.dart';
import 'organization_status.dart';

part 'organization_query.freezed.dart';
part 'organization_query.g.dart';

class OrganizationInclude {
  static const String files = 'file';
  static const String numberOfActivities = 'numberOfActivities';
}

@freezed
class OrganizationQuery with _$OrganizationQuery {
  @JsonSerializable(includeIfNull: false)
  const factory OrganizationQuery({
    int? limit,
    int? offset,
    int? cursor,
    @CommaSeparatedIntsConverter() List<int>? id,
    @CommaSeparatedIntsConverter() List<int>? excludeId,
    String? name,
    bool? joined,
    OrganizationStatus? status,
    OrganizationMemberStatus? memberStatus,
    @CommaSeparatedIntsConverter() List<int>? skill,
    String? locality,
    String? region,
    String? country,
    double? lat,
    double? lng,
    double? radius,
    @CommaSeparatedStringsConverter() List<String>? include,
  }) = _OrganizationQuery;

  factory OrganizationQuery.fromJson(Map<String, dynamic> json) =>
      _$OrganizationQueryFromJson(json);
}
