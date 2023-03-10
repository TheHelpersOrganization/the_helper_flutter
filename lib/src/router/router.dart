import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_auth_flutter_riverpod/src/features/authentication/presentation/account_verification_completed_screen.dart';
import 'package:simple_auth_flutter_riverpod/src/features/authentication/presentation/account_verification_screen.dart';
import 'package:simple_auth_flutter_riverpod/src/features/authentication/presentation/login_screen.dart';
import 'package:simple_auth_flutter_riverpod/src/features/authentication/presentation/profile_widget.dart';
import 'package:simple_auth_flutter_riverpod/src/features/splash/presentation/splash_screen.dart';

import '../features/authentication/presentation/profile_w.dart';
import './router_notifier.dart';
import '../features/change_role/presentation/change_role_screen.dart';
import '../features/change_role/presentation/home_screen.dart';

final routes = [
  GoRoute(
    name: AppRoute.splash.name,
    path: AppRoute.splash.path,
    builder: (context, state) => const SplashScreen(),
  ),
  GoRoute(
    name: AppRoute.home.name,
    path: AppRoute.home.path,
    builder: (context, state) => const ProfileW(),
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
      builder: (context, state) => const AccountVerificationCompletedScreen()),
  GoRoute(
      name: AppRoute.profile.name,
      path: AppRoute.profile.path,
      builder: (context, state) => const HomeScreen()),
  GoRoute(
      name: AppRoute.activities.name,
      path: AppRoute.activities.path,
      builder: (context, state) => const HomeScreen()),
  GoRoute(
      name: AppRoute.news.name,
      path: AppRoute.news.path,
      builder: (context, state) => const HomeScreen()),
  GoRoute(
      name: AppRoute.chat.name,
      path: AppRoute.chat.path,
      builder: (context, state) => const HomeScreen()),
  GoRoute(
      name: AppRoute.notification.name,
      path: AppRoute.notification.path,
      builder: (context, state) => const HomeScreen()),
  GoRoute(
      name: AppRoute.report.name,
      path: AppRoute.report.path,
      builder: (context, state) => const HomeScreen()),
  GoRoute(
      name: AppRoute.settings.name,
      path: AppRoute.settings.path,
      builder: (context, state) => const HomeScreen()),
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
  ;

  const AppRoute({required this.path, required this.name});

  final String path;
  final String name;
}

final routerProvider = Provider.autoDispose<GoRouter>((ref) {
  final notifier = ref.watch(routerNotifierProvider.notifier);

  return GoRouter(
    refreshListenable: notifier,
    initialLocation: AppRoute.splash.path,
    routes: routes,
    redirect: notifier.redirect,
  );
});
