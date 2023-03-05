import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:simple_auth_flutter_riverpod/src/features/authentication/application/auth_service.dart';

// class LogoutController extends StateNotifier<AsyncValue<void>> {
//   LogoutController({required this.authRepository})
//       : super(const AsyncData(null));
//   final AuthRepository authRepository;

part 'logout_controller.g.dart';

@riverpod
class LogoutController extends _$LogoutController {
  @override
  FutureOr<void> build() {}

  Future<void> signOut() async {
    final authService = ref.read(authServiceProvider.notifier);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(authService.signOut);
  }
}

// final logoutControllerProvider =
//     StateNotifierProvider.autoDispose<LogoutController, AsyncValue<void>>(
//         (ref) {
//   return LogoutController(
//     authRepository: ref.watch(authRepositoryProvider),
//   );
// });
