import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_auth_flutter_riverpod/src/common/screens/screen404.dart';
import 'package:simple_auth_flutter_riverpod/src/common/widget/bottom_navigation_bar/bottom_navigator.dart';
import 'package:simple_auth_flutter_riverpod/src/features/authentication/presentation/account_verification_completed_screen.dart';
import 'package:simple_auth_flutter_riverpod/src/features/authentication/presentation/account_verification_screen.dart';
import 'package:simple_auth_flutter_riverpod/src/features/authentication/presentation/login_screen.dart';
import 'package:simple_auth_flutter_riverpod/src/features/menu/presentation/screens/menu_screen.dart';
import 'package:simple_auth_flutter_riverpod/src/features/splash/presentation/splash_screen.dart';

import '../features/profile/presentation/profile_screen.dart';
import './router_notifier.dart';
import '../features/change_role/presentation/screens/change_role_screen.dart';
import '../features/change_role/presentation/screens/home_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>();

final routes = [
  ShellRoute(
    navigatorKey: _shellNavigatorKey,
    builder: (context, state, child) {
      return CustomBottomNavigator(child: child);
    },
    routes: [
      GoRoute(
        name: AppRoute.splash.name,
        path: AppRoute.splash.path,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        name: AppRoute.home.name,
        path: AppRoute.home.path,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
          name: AppRoute.login.name,
          path: AppRoute.login.path,
          builder: (context, state) => const LoginScreen()),
      GoRoute(
          name: AppRoute.changeRole.name,
          path: AppRoute.changeRole.path,
          builder: (context, state) => const ChangeRoleScreen()),
      GoRoute(
          name: AppRoute.accountVerification.name,
          path: AppRoute.accountVerification.path,
          builder: (context, state) => const AccountVerificationScreen()),
      GoRoute(
          name: AppRoute.accountVerificationCompleted.name,
          path: AppRoute.accountVerificationCompleted.path,
          builder: (context, state) =>
              const AccountVerificationCompletedScreen()),
      GoRoute(
          name: AppRoute.profile.name,
          path: AppRoute.profile.path,
          builder: (context, state) => const DevelopingScreen()),
      GoRoute(
          name: AppRoute.activities.name,
          path: AppRoute.activities.path,
          builder: (context, state) => const DevelopingScreen()),
      GoRoute(
          name: AppRoute.news.name,
          path: AppRoute.news.path,
          builder: (context, state) => const DevelopingScreen()),
      GoRoute(
          name: AppRoute.chat.name,
          path: AppRoute.chat.path,
          builder: (context, state) => const DevelopingScreen()),
      GoRoute(
          name: AppRoute.notification.name,
          path: AppRoute.notification.path,
          builder: (context, state) => const DevelopingScreen()),
      GoRoute(
          name: AppRoute.report.name,
          path: AppRoute.report.path,
          builder: (context, state) => const DevelopingScreen()),
      GoRoute(
          name: AppRoute.settings.name,
          path: AppRoute.settings.path,
          builder: (context, state) => const DevelopingScreen()),
      GoRoute(
        name: AppRoute.menu.name,
        path: AppRoute.menu.path,
        builder: (context, state) => const MenuScreen()),
    ]
  )
];

enum AppRoute {
  splash(path: '/splash', name: 'splash'), // Internal access only
  home(path: '/', name: 'home'),
  changeRole(path: '/change-role', name: 'change-role'),
  login(path: '/login', name: 'login'),
  accountVerification(
      path: '/account-verification', name: 'account-verification'),
  accountVerificationCompleted(
      path: '/account-verification-completed',
      name: 'account-verification-completed'),
  profile(path: '/profile', name: 'profile'),
  activities(path: '/activities', name: 'activities'),
  news(path: '/news', name: 'news'),
  chat(path: '/chat', name: 'chat'),
  notification(path: '/notification', name: 'notification'),
  report(path: '/report', name: 'report'),
  settings(path: '/settings', name: 'setting'),
  //Admin feature
  menu(
    path: '/menu',
    name: 'menu',
  );

  const AppRoute({
    required this.path,
    required this.name,
  });

  final String path;
  final String name;
  //final List<AppRoute>? routes;
}

final routerProvider = Provider.autoDispose<GoRouter>((ref) {
  final notifier = ref.watch(routerNotifierProvider.notifier);

  return GoRouter(
    refreshListenable: notifier,
    initialLocation: AppRoute.splash.path,
    navigatorKey: _rootNavigatorKey,
    routes: routes,
    redirect: notifier.redirect,
  );
});
