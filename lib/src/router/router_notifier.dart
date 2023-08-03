import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/features/authentication/application/auth_service.dart';
import 'package:the_helper/src/router/router.dart';

// Need to implement Listenable so that GoRouter can listen
class RouterNotifier extends Notifier<bool> implements Listenable {
  bool _isAuth = false;
  VoidCallback? _routerListener;

  @override
  bool build() {
    final authState = ref.watch(authServiceProvider);
    _isAuth = authState.valueOrNull?.token != null;
    // _isAuth = authState.valueOrNull?.token == null;
    ref.listenSelf((_, __) {
      if (!state) return;
      _routerListener?.call();
    });
    return authState.when(
      data: (data) => true,
      error: (_, __) => true,
      loading: () => false,
    );
  }

  /// Redirects the user when our authentication changes
  String? redirect(BuildContext context, GoRouterState state) {
    if (!this.state) {
      return null;
    }

    //FlutterNativeSplash.remove();

    // Navigate to home if user has logged in
    final isLoggingIn = state.fullPath == AppRoute.login.path;
    if (isLoggingIn) return _isAuth ? AppRoute.home.path : null;

    return _isAuth ? null : AppRoute.login.path;
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

final routerNotifierProvider = NotifierProvider<RouterNotifier, bool>(() {
  return RouterNotifier();
});
