import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/exception/backend_exception.dart';
import 'package:the_helper/src/features/authentication/application/auth_service.dart';
import 'package:the_helper/src/router/router.dart';

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
    } catch (ex, st) {
      print(st);
      print(ex);
      state = AsyncValue.error('Cannot verify OTP', st);
    }
  }

  Future<void> sendOtp() async {
    if (state.isLoading) {
      return;
    }
    try {
      state = const AsyncValue.loading();
      final authService = ref.read(authServiceProvider.notifier);
      await authService.sendOtp();
      state = const AsyncValue.data(null);
    } on BackendException catch (ex) {
      state = AsyncValue.error(ex.error.message, StackTrace.current);
    } catch (ex) {
      state = AsyncValue.error('Cannot send OTP', StackTrace.current);
    }
  }
}

final accountVerificationControllerProvider =
    AutoDisposeAsyncNotifierProvider<AccountVerificationController, void>(
        () => AccountVerificationController());

class ResendOtpCountdown extends AutoDisposeNotifier<int> {
  Timer? _timer;

  @override
  int build() {
    if (_timer != null) {
      _timer?.cancel();
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state > 0) {
        state = state - 1;
      } else {
        _timer?.cancel();
        _timer = null;
      }
    });
    ref.onDispose(() {
      _timer?.cancel();
      _timer = null;
    });
    return 0;
  }

  void reset() {
    if (_timer == null) {
      state = build();
    }
  }
}

final resendOtpCountdownProvider =
    AutoDisposeNotifierProvider<ResendOtpCountdown, int>(() {
  return ResendOtpCountdown();
});
