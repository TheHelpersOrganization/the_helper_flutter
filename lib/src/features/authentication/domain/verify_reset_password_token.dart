import 'package:freezed_annotation/freezed_annotation.dart';

part 'verify_reset_password_token.freezed.dart';
part 'verify_reset_password_token.g.dart';

@freezed
class VerifyResetPasswordToken with _$VerifyResetPasswordToken {
  const factory VerifyResetPasswordToken({
    required String email,
    required String token,
  }) = _VerifyResetPasswordToken;

  factory VerifyResetPasswordToken.fromJson(Map<String, dynamic> json) =>
      _$VerifyResetPasswordTokenFromJson(json);
}
