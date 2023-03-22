import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/authentication/application/auth_service.dart';

class LogoutController {
  final AuthService _authService;

  LogoutController(this._authService);

  Future<void> signOut() async {
    await _authService.signOut();
  }
}

final logoutControllerProvider = Provider(
    (ref) => LogoutController(ref.watch(authServiceProvider.notifier)));
