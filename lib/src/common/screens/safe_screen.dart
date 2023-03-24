import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/screens/error_screen.dart';
import 'package:the_helper/src/common/screens/splash_screen.dart';
import 'package:the_helper/src/features/authentication/application/auth_service.dart';

class SafeScreen extends ConsumerWidget {
  final Widget child;

  const SafeScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authServiceProvider);

    return auth.when(
      data: (data) => child,
      error: (_, __) => const ErrorScreen(),
      loading: () => const SplashScreen(
        enableIndicator: true,
      ),
    );
  }
}
