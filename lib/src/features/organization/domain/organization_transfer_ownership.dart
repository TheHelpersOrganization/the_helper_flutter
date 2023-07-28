import 'package:freezed_annotation/freezed_annotation.dart';

part 'organization_transfer_ownership.freezed.dart';
part 'organization_transfer_ownership.g.dart';

@freezed
class OrganizationTransferOwnership with _$OrganizationTransferOwnership {
  @JsonSerializable(includeIfNull: false)
  factory OrganizationTransferOwnership({
    required int memberId,
    required String password,
  }) = _OrganizationTransferOwnership;

  factory OrganizationTransferOwnership.fromJson(Map<String, dynamic> json) =>
      _$OrganizationTransferOwnershipFromJson(json);
}
