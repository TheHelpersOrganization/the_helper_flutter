import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_auth_flutter_riverpod/src/common/exception/backend_exception.dart';
import 'package:simple_auth_flutter_riverpod/src/features/authentication/application/auth_service.dart';
import 'package:simple_auth_flutter_riverpod/src/router/router.dart';

final otpEditingControllerProvider = Provider.autoDispose((ref) {
  return TextEditingController();
});

class AccountVerificationController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> verifyOtp(String otp) async {
    if (otp.length < 6) {
      state = AsyncValue.error('Please enter the OTP', StackTrace.current);
      return;
    }
    try {
      state = const AsyncValue.loading();
      final authService = ref.read(authServiceProvider.notifier);
      await authService.verifyAccount(otp);
      // No exception means verification is successful
      // Navigate when complete
      ref
          .read(routerProvider)
          .goNamed(AppRoute.accountVerificationCompleted.name);
    } on BackendException catch (ex) {
      state = AsyncValue.error(ex.error.message, StackTrace.current);
    } catch (ex) {
      state = AsyncValue.error('Cannot verify OTP', StackTrace.current);
    }
  }

  Future<void> sendOtp() async {
    try {
      state = const AsyncValue.loading();
      final authService = ref.read(authServiceProvider.notifier);
      await authService.sendOtp();
      state = const AsyncValue.data(null);
    } on BackendException catch (ex) {
      state = AsyncValue.error(ex.error.message, StackTrace.current);
    } catch (ex) {
      print(ex);
      state = AsyncValue.error('Cannot send OTP', StackTrace.current);
    }
  }
}

final accountVerificationControllerProvider =
    AutoDisposeAsyncNotifierProvider<AccountVerificationController, void>(
        () => AccountVerificationController());
