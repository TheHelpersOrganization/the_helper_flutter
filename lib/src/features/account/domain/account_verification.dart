import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_verification.freezed.dart';
part 'account_verification.g.dart';

@freezed
class AccountVerificationModel with _$AccountVerificationModel {
  factory AccountVerificationModel({
    required int performedBy,
    @Default(true) bool isVerified,
    required String note,
    required DateTime createdAt,

  }) = _AccountVerificationModel;

  factory AccountVerificationModel.fromJson(Map<String, dynamic> json) =>
      _$AccountVerificationModelFromJson(json);
}
