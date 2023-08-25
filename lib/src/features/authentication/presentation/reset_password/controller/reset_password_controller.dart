import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/features/authentication/data/auth_repository.dart';
import 'package:the_helper/src/features/authentication/domain/request_reset_password.dart';
import 'package:the_helper/src/features/authentication/domain/reset_password.dart';
import 'package:the_helper/src/features/authentication/domain/verify_reset_password_token.dart';
import 'package:the_helper/src/utils/async_value.dart';

enum ResetPasswordStep {
  requestResetPassword,
  verifyResetPasswordToken,
  changePassword,
  changePasswordSuccess,
}

final resetPasswordStepProvider =
    StateProvider.autoDispose<ResetPasswordStep>((ref) {
  return ResetPasswordStep.requestResetPassword;
});

final emailTextEditingControllerProvider =
    ChangeNotifierProvider.autoDispose((ref) => TextEditingController());

final otpTextEditingControllerProvider =
    ChangeNotifierProvider.autoDispose((ref) => TextEditingController());

final formKey = GlobalKey<FormBuilderState>();

final passwordTextEditingControllerProvider =
    ChangeNotifierProvider.autoDispose((ref) => TextEditingController());

final hidePasswordProvider = StateProvider.autoDispose<bool>((ref) {
  return true;
});

class RequestResetPasswordController extends AutoDisposeAsyncNotifier {
  late AuthRepository _authRepository;

  @override
  FutureOr build() {
    _authRepository = ref.watch(authRepositoryProvider);
  }

  Future<void> requestResetPassword({
    required String email,
  }) async {
    state = const AsyncValue.loading();
    state = await guardAsyncValue(
      () => _authRepository.requestResetPassword(
        RequestResetPassword(email: email),
      ),
    );
    if (state.hasError) {
      return;
    }
    ref.read(resetPasswordStepProvider.notifier).state =
        ResetPasswordStep.verifyResetPasswordToken;
  }
}

final requestResetPasswordControllerProvider =
    AutoDisposeAsyncNotifierProvider<RequestResetPasswordController, dynamic>(
  () => RequestResetPasswordController(),
);

class VerifyResetPasswordTokenController extends AutoDisposeAsyncNotifier {
  late AuthRepository _authRepository;

  @override
  FutureOr build() {
    _authRepository = ref.watch(authRepositoryProvider);
  }

  Future<void> verifyResetPasswordToken({
    required String email,
    required String token,
  }) async {
    state = const AsyncValue.loading();
    state = await guardAsyncValue(
      () => _authRepository.verifyResetPasswordToken(
        VerifyResetPasswordToken(email: email, token: token),
      ),
    );
    if (state.hasError) {
      return;
    }

    ref.read(resetPasswordStepProvider.notifier).state =
        ResetPasswordStep.changePassword;
  }
}

final verifyResetPasswordTokenControllerProvider =
    AutoDisposeAsyncNotifierProvider<VerifyResetPasswordTokenController,
        dynamic>(
  () => VerifyResetPasswordTokenController(),
);

class ResetPasswordController extends AutoDisposeAsyncNotifier {
  late AuthRepository _authRepository;

  @override
  FutureOr build() {
    _authRepository = ref.watch(authRepositoryProvider);
  }

  Future<void> resetPassword({
    required String email,
    required String token,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    state = await guardAsyncValue(
      () => _authRepository.resetPassword(
        ResetPassword(email: email, token: token, password: password),
      ),
    );
    if (state.hasError) {
      return;
    }
    ref.read(resetPasswordStepProvider.notifier).state =
        ResetPasswordStep.changePasswordSuccess;
  }
}

final resetPasswordControllerProvider =
    AutoDisposeAsyncNotifierProvider<ResetPasswordController, dynamic>(
  () => ResetPasswordController(),
);
