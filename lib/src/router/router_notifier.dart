import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_auth_flutter_riverpod/src/features/authentication/data/auth_repository.dart';

import 'router.dart';

// Need to implement Listenable so that GoRouter can listen
class RouterNotifier extends AutoDisposeAsyncNotifier<void>
    implements Listenable {
  bool _isAuth = false;
  VoidCallback? _routerListener;

  @override
  Future<void> build() async {
    _isAuth = await ref
        .watch(authStateChangesProvider.selectAsync((data) => data != null));

    ref.listenSelf((_, __) {
      if (state.isLoading) return;
      _routerListener?.call();
    });
  }

  /// Redirects the user when our authentication changes
  String? redirect(BuildContext context, GoRouterState state) {
    if (this.state.isLoading || this.state.hasError) return null;

    // // Navigate to home if user has logged in
    final isLoggingIn = state.location == AppRoute.login.path;
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

final routerNotifierProvider =
    AutoDisposeAsyncNotifierProvider<RouterNotifier, void>(() {
  return RouterNotifier();
});
