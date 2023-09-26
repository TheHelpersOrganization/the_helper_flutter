import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/features/authentication/application/auth_service.dart';
import 'package:the_helper/src/router/router.dart';

// Need to implement Listenable so that GoRouter can listen
class RouterNotifier extends Notifier<bool> implements Listenable {
  bool _isAuth = false;
  int? _accountId;
  VoidCallback? _routerListener;

  @override
  bool build() {
    final authState = ref.watch(authServiceProvider);
    _isAuth = authState.valueOrNull?.token != null;
    _accountId = authState.valueOrNull?.account.id;
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
  String? redirect(BuildContext context, GoRouterState routerState) {
    if (!state) {
      return null;
    }

    // Don't redirect if we're already on the reset password screen
    if (routerState.fullPath == AppRoute.resetPassword.path) {
      return null;
    }

    // Navigate to home if user has logged in
    final isLoggingIn = routerState.fullPath == AppRoute.login.path;
    if (isLoggingIn) return _isAuth ? AppRoute.home.path : null;

    // Navigate to login if user has logged out
    if (!_isAuth) {
      return AppRoute.login.path;
    }

    // Navigate to my profile if profile id matches user id
    final isProfile = routerState.fullPath?.contains(
            '${AppRoute.profile.path}/${AppRoute.otherProfile.path}') ??
        false;
    if (isProfile) {
      final profileId = routerState.pathParameters[AppRouteParameter.profileId];
      if (profileId != null &&
          _accountId != null &&
          profileId == _accountId.toString()) {
        return AppRoute.profile.path;
      }
    }

    return null;
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
