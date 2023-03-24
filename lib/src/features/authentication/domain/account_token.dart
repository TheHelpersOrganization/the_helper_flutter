import 'package:flutter/foundation.dart';
import 'package:the_helper/src/features/authentication/domain/token.dart';

import 'account.dart';

/// Simple class representing the user UID and email.
@immutable
class AccountToken {
  final Token token;
  final Account account;

  const AccountToken({
    required this.token,
    required this.account,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccountToken &&
          runtimeType == other.runtimeType &&
          token == other.token &&
          account == other.account);

  @override
  int get hashCode => token.hashCode ^ account.hashCode;

  @override
  String toString() {
    return 'AccountToken{ token: $token, account: $account,}';
  }

  AccountToken copyWith({
    Token? token,
    Account? account,
  }) {
    return AccountToken(
      token: token ?? this.token,
      account: account ?? this.account,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'token': token,
      'account': account,
    };
  }

  factory AccountToken.fromMap(Map<String, dynamic> map) {
    return AccountToken(
      token: Token.fromJson(map['token']),
      account: Account.fromMap(map['account']),
    );
  }
}
