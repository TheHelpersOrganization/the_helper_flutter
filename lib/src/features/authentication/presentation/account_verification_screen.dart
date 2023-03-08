import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:simple_auth_flutter_riverpod/src/common/extension/build_context.dart';
import 'package:simple_auth_flutter_riverpod/src/common/extension/widget.dart';
import 'package:simple_auth_flutter_riverpod/src/common/widget/button/primary_button.dart';
import 'package:simple_auth_flutter_riverpod/src/features/authentication/presentation/account_verification_controller.dart';
import 'package:simple_auth_flutter_riverpod/src/features/authentication/presentation/account_verification_header_widget.dart';
import 'package:simple_auth_flutter_riverpod/src/features/authentication/presentation/account_verification_otp_field_widget.dart';
import 'package:simple_auth_flutter_riverpod/src/features/authentication/presentation/account_verification_send_otp_widget.dart';

class AccountVerificationScreen extends ConsumerWidget {
  const AccountVerificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final otpController = ref.watch(otpEditingControllerProvider);
    final accountVerificationController =
        ref.read(accountVerificationControllerProvider.notifier);
    final accountVerificationControllerState =
        ref.watch(accountVerificationControllerProvider);

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(32),
        alignment: Alignment.center,
        child: Column(
          children: [
            SvgPicture.asset(
              'images/account_verification.svg',
              fit: BoxFit.fitHeight,
              height: context.mediaQuery.size.height * 0.27,
            ),
            const AccountVerificationHeaderWidget(),
            const AccountVerificationOtpFieldWidget(),
            accountVerificationControllerState.hasError
                ? Text(
                    'Error: ${accountVerificationControllerState.error}',
                    style: TextStyle(color: context.theme.colorScheme.error),
                  )
                : const Text(''),
            const AccountVerificationSendOtpWidget(),
            PrimaryButton(
              isLoading: accountVerificationControllerState.isLoading,
              onPressed: () {
                accountVerificationController.verifyOtp(otpController.text);
              },
              child: const Text('Send'),
            )
          ].padding(const EdgeInsets.symmetric(vertical: 16)),
        ),
      ),
    );
  }
}
