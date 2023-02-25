import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:simple_auth_flutter_riverpod/src/features/authentication/data/auth_repository.dart';

part 'login_controller.g.dart';

@riverpod
class LoginController extends _$LoginController {
  @override
  FutureOr<void> build() {}
  // Future<void> signInAnonymously() async {
  //   final authService = ref.read(authServiceProvider);
  //   state = const AsyncLoading();
  //   state = await AsyncValue.guard(authService.signInAnonymously);
  // }
  Future<void> signIn(String email, String password) async {
    final authRepository = ref.read(authRepositoryProvider);
    state = const AsyncLoading();
    state =
        await AsyncValue.guard(() => authRepository.signIn(email, password));
  }
}
