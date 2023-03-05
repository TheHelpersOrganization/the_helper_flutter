import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_auth_flutter_riverpod/src/common/extension/build_context.dart';
import 'package:simple_auth_flutter_riverpod/src/common/extension/widget.dart';
import 'package:simple_auth_flutter_riverpod/src/common/widget/button/primary_button.dart';
import 'package:simple_auth_flutter_riverpod/src/router/router.dart';

class AccountVerificationCompletedScreen extends ConsumerWidget {
  const AccountVerificationCompletedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(32),
        alignment: Alignment.center,
        child: Column(
          children: [
            SvgPicture.asset(
              'images/account_verification_completed.svg',
              fit: BoxFit.fitHeight,
              height: context.mediaQuery.size.height * 0.27,
            ),
            Text(
              'Verification Completed',
              style: Theme.of(context).textTheme.headlineMedium?.apply(
                    fontWeightDelta: FontWeight.bold.value,
                    color: Colors.black87,
                  ),
              textAlign: TextAlign.center,
            ),
            Text(
              'Great. Now you can enjoy all the features of The Helpers!',
              style: context.theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            PrimaryButton(
                child: const Text('Go to Home'),
                onPressed: () => context.goNamed(AppRoute.home.name)),
          ].padding(const EdgeInsets.symmetric(vertical: 16)),
        ),
      ),
    );
  }
}
