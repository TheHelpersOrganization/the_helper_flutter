import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_auth_flutter_riverpod/src/features/authentication/data/auth_repository.dart';
import 'package:simple_auth_flutter_riverpod/src/features/authentication/presentation/login_screen.dart';
import 'package:simple_auth_flutter_riverpod/src/features/change_role/presentation/screens/change_role_screen.dart';

class AuthScreen extends ConsumerWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);
    return authState.maybeWhen(
      data: (user) => user != null ? const ChangeRoleScreen() : const LoginScreen(),
      // TODO: Should also handle errors
      orElse: () => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
