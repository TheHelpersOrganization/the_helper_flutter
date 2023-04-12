import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/features/change_role/domain/user_role.dart';

part 'account.freezed.dart';
part 'account.g.dart';

@freezed
class Account with _$Account {
  @JsonSerializable(includeIfNull: false)
  const factory Account({
    required int id,
    required String email,
    required List<Role> roles,
    required bool isAccountDisabled,
    required bool isAccountVerified,
  }) = _Account;

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);
}
