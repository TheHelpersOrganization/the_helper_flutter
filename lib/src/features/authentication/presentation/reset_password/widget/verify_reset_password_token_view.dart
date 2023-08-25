import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/widget/loading_overlay.dart';
import 'package:the_helper/src/features/authentication/presentation/reset_password/controller/reset_password_controller.dart';
import 'package:the_helper/src/utils/async_value_ui.dart';

class VerifyResetPasswordTokenView extends ConsumerWidget {
  const VerifyResetPasswordTokenView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final verifyResetPasswordTokenState =
        ref.watch(verifyResetPasswordTokenControllerProvider);
    final emailTextEditingController =
        ref.watch(emailTextEditingControllerProvider);
    final otpTextEditingController =
        ref.watch(otpTextEditingControllerProvider);

    ref.listen(
      verifyResetPasswordTokenControllerProvider,
      (previous, next) {
        next.showSnackbarOnError(context);
      },
    );

    return LoadingOverlay(
      isLoading: verifyResetPasswordTokenState.isLoading,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'We have sent an OTP to your email address. Enter the OTP below to continue.',
              ),
              const SizedBox(height: 24),
              TextField(
                controller: otpTextEditingController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'OTP',
                  hintText: 'Enter OTP',
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () {
                  ref
                      .read(verifyResetPasswordTokenControllerProvider.notifier)
                      .verifyResetPasswordToken(
                        email: emailTextEditingController.text,
                        token: otpTextEditingController.text,
                      );
                },
                child: const Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
