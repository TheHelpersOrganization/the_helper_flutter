import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/common/extension/widget.dart';
import 'package:the_helper/src/common/widget/button/primary_button.dart';
import 'package:the_helper/src/features/authentication/presentation/account_verification_controller.dart';
import 'package:the_helper/src/features/authentication/presentation/account_verification_header_widget.dart';
import 'package:the_helper/src/features/authentication/presentation/account_verification_otp_field_widget.dart';
import 'package:the_helper/src/features/authentication/presentation/account_verification_send_otp_widget.dart';

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
        child: SingleChildScrollView(
          child: Column(
            children: [
              SvgPicture.asset(
                kIsWeb
                    ? 'images/account_verification.svg'
                    : 'assets/images/account_verification.svg',
                fit: BoxFit.fitHeight,
                height: context.mediaQuery.size.height * 0.27,
              ),
              const AccountVerificationHeaderWidget(),
              const AccountVerificationOtpFieldWidget(),
              accountVerificationControllerState.hasError
                  ? Text(
                      '${accountVerificationControllerState.error}',
                      style: TextStyle(color: context.theme.colorScheme.error),
                    )
                  : const Text(''),
              const AccountVerificationSendOtpWidget(),
              PrimaryButton(
                isLoading: accountVerificationControllerState.isLoading,
                onPressed: () {
                  accountVerificationController.verifyOtp(otpController.text);
                },
                child: const Text('Verify'),
              )
            ].padding(const EdgeInsets.symmetric(vertical: 16)),
          ),
        ),
      ),
    );
  }
}
