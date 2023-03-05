import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_auth_flutter_riverpod/src/common/extension/build_context.dart';
import 'package:simple_auth_flutter_riverpod/src/common/extension/widget.dart';
import 'package:simple_auth_flutter_riverpod/src/features/authentication/presentation/account_verification_controller.dart';

class AccountVerificationSendOtpWidget extends ConsumerWidget {
  const AccountVerificationSendOtpWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountVerificationController =
        ref.read(accountVerificationControllerProvider.notifier);
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Don't receive the code?"),
          RichText(
              text: TextSpan(
                  text: 'Send again',
                  style: TextStyle(color: context.theme.primaryColor),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      accountVerificationController.sendOtp();
                    }))
        ].padding(const EdgeInsets.symmetric(horizontal: 2, vertical: 2)));
  }
}
