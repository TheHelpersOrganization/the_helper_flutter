import 'package:freezed_annotation/freezed_annotation.dart';

part 'reject_member_data.freezed.dart';
part 'reject_member_data.g.dart';

@freezed
class RejectMemberData with _$RejectMemberData {
  @JsonSerializable(includeIfNull: false)
  factory RejectMemberData({
    String? rejectionReason,
  }) = _RejectMemberData;

  factory RejectMemberData.fromJson(Map<String, dynamic> json) =>
      _$RejectMemberDataFromJson(json);
}
