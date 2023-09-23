import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/widget/alert.dart';
import 'package:the_helper/src/router/router.dart';

class EmailVerificationAlert extends StatelessWidget {
  const EmailVerificationAlert({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Alert(
      leading: const Icon(
        Icons.info_outline,
      ),
      message:
      const Text('Verify your account \'s email now to use other features'),
      action: IconButton(
        onPressed: () {
          context.goNamed(AppRoute.accountVerification.name);
        },
        icon: const Icon(Icons.navigate_next_outlined),
      ),
    );
  }
}
