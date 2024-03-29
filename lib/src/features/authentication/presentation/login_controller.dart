import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/authentication/application/auth_service.dart';

part 'login_controller.g.dart';

final passwordVisibilityProvider = StateProvider<bool>((ref) => true);

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

final volunteerIdTextEditingControllerProvider =
    ChangeNotifierProvider<TextEditingController>(
        (ref) => TextEditingController());
