import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:simple_auth_flutter_riverpod/src/features/authentication/presentation/account_verification_controller.dart';

class AccountVerificationOtpFieldWidget extends ConsumerWidget {
  const AccountVerificationOtpFieldWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final otpController = ref.read(otpEditingControllerProvider);
    return PinCodeTextField(
        appContext: context,
        length: 6,
        keyboardType: TextInputType.visiblePassword,
        controller: otpController,
        animationDuration: Duration.zero,
        autoDismissKeyboard: false,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        pinTheme:
            PinTheme(activeColor: Colors.grey, inactiveColor: Colors.grey),
        onChanged: (String value) {});
  }
}
