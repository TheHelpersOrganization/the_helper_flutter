import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_auth_flutter_riverpod/src/common/extension/widget.dart';
import 'package:simple_auth_flutter_riverpod/src/features/authentication/application/auth_service.dart';

class AccountVerificationHeaderWidget extends ConsumerWidget {
  const AccountVerificationHeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authServiceProvider);
    return Column(
      children: [
        Text(
          'Verify Your Account',
          style: Theme.of(context).textTheme.headlineMedium?.apply(
                fontWeightDelta: FontWeight.bold.value,
                color: Colors.black87,
              ),
          textAlign: TextAlign.center,
        ),
        Text(
          'Enter 6-digit code sent to ${authState.valueOrNull?.account.email ?? 'unknown account'}',
          textAlign: TextAlign.center,
        ),
      ].padding(const EdgeInsets.symmetric(vertical: 8)),
    );
  }
}
