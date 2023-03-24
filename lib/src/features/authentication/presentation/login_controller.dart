import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/authentication/application/auth_service.dart';

part 'login_controller.g.dart';

@riverpod
class LoginController extends _$LoginController {
  @override
  FutureOr<void> build() {}

  Future<void> signIn(String email, String password) async {
    final authService = ref.read(authServiceProvider.notifier);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => authService.signIn(email, password));
  }
}
