import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/widget/loading_overlay.dart';
import 'package:the_helper/src/features/authentication/presentation/reset_password/controller/reset_password_controller.dart';
import 'package:the_helper/src/utils/async_value_ui.dart';

class RequestResetPasswordView extends ConsumerWidget {
  const RequestResetPasswordView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailTextEditingController =
        ref.watch(emailTextEditingControllerProvider);
    final requestResetPasswordState =
        ref.watch(requestResetPasswordControllerProvider);

    ref.listen(
      requestResetPasswordControllerProvider,
      (previous, next) {
        next.showSnackbarOnError(context);
      },
    );

    return LoadingOverlay(
      isLoading: requestResetPasswordState.isLoading,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter your email address and we will send you an OTP to reset your password.',
              ),
              const SizedBox(height: 24),
              TextField(
                controller: emailTextEditingController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                  hintText: 'Enter your email',
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () async {
                  await ref
                      .read(requestResetPasswordControllerProvider.notifier)
                      .requestResetPassword(
                        email: emailTextEditingController.text,
                      );
                },
                child: const Text('Send OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
