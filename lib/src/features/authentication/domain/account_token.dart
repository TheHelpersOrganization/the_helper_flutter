import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/features/authentication/domain/token.dart';

import 'account.dart';

part 'account_token.freezed.dart';
part 'account_token.g.dart';

@freezed
class AccountToken with _$AccountToken {
  const factory AccountToken({
    required Token token,
    required Account account,
  }) = _AccountToken;

  factory AccountToken.fromJson(Map<String, dynamic> json) =>
      _$AccountTokenFromJson(json);
}
