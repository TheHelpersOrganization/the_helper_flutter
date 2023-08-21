import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/router/router.dart';

class ChangePasswordSuccessView extends StatelessWidget {
  const ChangePasswordSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/images/ok.svg',
          height: 200,
        ),
        const SizedBox(height: 36),
        Text('Your password has been changed successfully.',
            textAlign: TextAlign.center,
            style: context.theme.textTheme.titleLarge),
        const SizedBox(height: 36),
        FilledButton(
          onPressed: () {
            context.goNamed(AppRoute.login.name);
          },
          child: const Text('Back to Login'),
        ),
      ],
    );
  }
}
