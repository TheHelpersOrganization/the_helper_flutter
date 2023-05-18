import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/common/extension/build_context.dart';
import 'package:the_helper/src/router/router.dart';

class DevelopingScreen extends StatelessWidget {
  const DevelopingScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SvgPicture.asset('assets/images/404.svg'),
            Text(
              'Page Not Found',
              style: context.theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              'The page you\'re looking for does not exist',
              style: context.theme.textTheme.bodyLarge,
            ),
            const SizedBox(
              height: 24,
            ),
            FilledButton(
              onPressed: () => context.goNamed(AppRoute.home.name),
              child: const Text('Back to Home'),
            )
          ],
        ),
      ),
    );
  }
}
