import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/authentication/application/auth_service.dart';

part 'register_controller.g.dart';

final passwordVisibilityProvider = StateProvider<bool>((ref) => true);

@riverpod
class RegisterController extends _$RegisterController {
  @override
  FutureOr<void> build() {}
  Future<void> register(
    String email,
    String password,
  ) async {
    final AuthService authService = ref.read(authServiceProvider.notifier);
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => authService.register(email, password));
  }
}
