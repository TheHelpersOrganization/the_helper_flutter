import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/extension/widget.dart';
import 'package:the_helper/src/features/authentication/presentation/account_verification_controller.dart';

class AccountVerificationSendOtpWidget extends ConsumerWidget {
  const AccountVerificationSendOtpWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountVerificationController =
        ref.read(accountVerificationControllerProvider.notifier);
    final resendOtpCountdown = ref.watch(resendOtpCountdownProvider);
    final isWaitingForOtp = resendOtpCountdown > 0;
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Don't receive the code?"),
          RichText(
            text: TextSpan(
              text: isWaitingForOtp
                  ? 'Send again in ${resendOtpCountdown}s'
                  : 'Send again',
              style: isWaitingForOtp
                  ? null
                  : TextStyle(color: context.theme.primaryColor),
              recognizer: isWaitingForOtp
                  ? null
                  : (TapGestureRecognizer()
                    ..onTap = () async {
                      await accountVerificationController.sendOtp();
                      if (context.mounted) {
                        ref.read(resendOtpCountdownProvider.notifier).reset();
                      }
                    }),
            ),
          )
        ].padding(const EdgeInsets.symmetric(horizontal: 2, vertical: 2)));
  }
}
