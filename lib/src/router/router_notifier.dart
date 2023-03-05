import 'package:flutter/widgets.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_auth_flutter_riverpod/src/features/authentication/application/auth_service.dart';
import 'package:simple_auth_flutter_riverpod/src/router/router.dart';

// Need to implement Listenable so that GoRouter can listen
class RouterNotifier extends AutoDisposeAsyncNotifier<void>
    implements Listenable {
  bool _isAuth = false;
  bool _isInitializing = true;
  VoidCallback? _routerListener;

  @override
  Future<void> build() async {
    final authState = ref.watch(authServiceProvider);
    _isAuth = authState.valueOrNull != null;
    _isInitializing = authState.isLoading;
    ref.listenSelf((_, __) {
      if (state.isLoading) return;
      _routerListener?.call();
    });
  }

  /// Redirects the user when our authentication changes
  String? redirect(BuildContext context, GoRouterState state) {
    // return null;
    if (this.state.isLoading || this.state.hasError || _isInitializing) {
      return null;
    }

    if (!_isInitializing) {
      FlutterNativeSplash.remove();
    }

    // Navigate to home or login after auto login has finished
    final isSplash = state.location == AppRoute.splash.path;
    if (isSplash) {
      return _isAuth ? AppRoute.home.path : AppRoute.login.path;
    }

    // Navigate to home if user has logged in
    final isLoggingIn = state.location == AppRoute.login.path;
    if (isLoggingIn) return _isAuth ? AppRoute.home.path : null;

    return _isAuth ? null : AppRoute.splash.path;
  }

  @override
  void addListener(VoidCallback listener) {
    _routerListener = listener;
  }

  @override
  void removeListener(VoidCallback listener) {
    _routerListener = null;
  }
}

final routerNotifierProvider =
    AutoDisposeAsyncNotifierProvider<RouterNotifier, void>(() {
  return RouterNotifier();
});
