import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'account_ban.dart';
import 'account_verification.dart';

part 'account.freezed.dart';
part 'account.g.dart';

@freezed
class AccountModel with _$AccountModel {
  factory AccountModel({
    int? id,
    required String email,
    @Default(false) bool isAccountDisabled,
    @Default(false) bool isAccountVerified,
    @Default(false) bool isEmailVerified,
    required DateTime createdAt,
    required DateTime updatedAt,
    List<AccountVerificationModel>? verificationList,
    List<AccountBanModel>? banList,
  }) = _AccountModel;

  factory AccountModel.fromJson(Map<String, dynamic> json) =>
      _$AccountModelFromJson(json);
}
