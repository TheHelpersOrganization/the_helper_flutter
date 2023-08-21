import 'package:freezed_annotation/freezed_annotation.dart';

part 'request_reset_password.freezed.dart';
part 'request_reset_password.g.dart';

@freezed
class RequestResetPassword with _$RequestResetPassword {
  const factory RequestResetPassword({
    required String email,
  }) = _RequestResetPassword;

  factory RequestResetPassword.fromJson(Map<String, dynamic> json) =>
      _$RequestResetPasswordFromJson(json);
}
