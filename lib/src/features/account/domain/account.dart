import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:the_helper/src/features/profile/domain/profile.dart';

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
    Profile? profile,
  }) = _AccountModel;

  factory AccountModel.fromJson(Map<String, dynamic> json) =>
      _$AccountModelFromJson(json);
}
