import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/screens/error_screen.dart';
import 'package:the_helper/src/common/screens/splash_screen.dart';
import 'package:the_helper/src/utils/app_service_provider.dart';

class SafeScreen extends ConsumerWidget {
  final Widget child;

  const SafeScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appService = ref.watch(appServiceProvider);

    return appService.when(
      data: (data) => child,
      error: (_, __) {
        return const ErrorScreen();
      },
      loading: () => const SplashScreen(
        enableIndicator: true,
      ),
    );
  }
}
