import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:the_helper/src/features/authentication/presentation/reset_password/controller/reset_password_controller.dart';
import 'package:the_helper/src/features/authentication/presentation/reset_password/widget/change_password_successfully.dart';
import 'package:the_helper/src/features/authentication/presentation/reset_password/widget/change_password_view.dart';
import 'package:the_helper/src/features/authentication/presentation/reset_password/widget/request_reset_password_view.dart';
import 'package:the_helper/src/features/authentication/presentation/reset_password/widget/verify_reset_password_token_view.dart';
import 'package:the_helper/src/router/router.dart';

class ResetPasswordScreen extends HookConsumerWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final step = ref.watch(resetPasswordStepProvider);
    // Keep track of the email entered by the user
    ref.watch(emailTextEditingControllerProvider);
    // Keep track of the OTP entered by the user
    ref.watch(otpTextEditingControllerProvider);

    return Scaffold(
      appBar: step == ResetPasswordStep.changePasswordSuccess
          ? null
          : AppBar(
              leading: BackButton(onPressed: () {
                if (step == ResetPasswordStep.requestResetPassword) {
                  context.goNamed(AppRoute.login.name);
                } else {
                  ref.read(resetPasswordStepProvider.notifier).state =
                      ResetPasswordStep.requestResetPassword;
                }
              }),
              title: switch (step) {
                ResetPasswordStep.requestResetPassword =>
                  const Text('Reset Password'),
                ResetPasswordStep.verifyResetPasswordToken =>
                  const Text('Enter OTP'),
                ResetPasswordStep.changePassword =>
                  const Text('Change Password'),
                ResetPasswordStep.changePasswordSuccess => null
              },
            ),
      body: switch (step) {
        ResetPasswordStep.requestResetPassword =>
          const RequestResetPasswordView(),
        ResetPasswordStep.verifyResetPasswordToken =>
          const VerifyResetPasswordTokenView(),
        ResetPasswordStep.changePassword => const ChangePasswordView(),
        ResetPasswordStep.changePasswordSuccess =>
          const ChangePasswordSuccessView(),
      },
    );
  }
}
