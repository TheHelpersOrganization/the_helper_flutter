import 'package:freezed_annotation/freezed_annotation.dart';

part 'reset_password.freezed.dart';
part 'reset_password.g.dart';

@freezed
class ResetPassword with _$ResetPassword {
  const factory ResetPassword({
    required String email,
    required String token,
    required String password,
  }) = _ResetPassword;

  factory ResetPassword.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordFromJson(json);
}
