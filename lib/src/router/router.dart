import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_auth_flutter_riverpod/src/features/authentication/presentation/login_screen.dart';

import './router_notifier.dart';
import '../features/change_role/presentation/screens/change_role_screen.dart';
import '../features/change_role/presentation/screens/home_screen.dart';

final routes = [
  GoRoute(
    name: AppRoute.home.name,
    path: AppRoute.home.path,
    builder: (context, state) => const HomeScreen(
      // role: state.params['role'],
    ),
  ),
  GoRoute(
      name: AppRoute.login.name,
      path: AppRoute.login.path,
      builder: (context, state) => const LoginScreen()),
  GoRoute(
      name: AppRoute.changeRole.name,
      path: AppRoute.changeRole.path,
      builder: (context, state) => const ChangeRoleScreen()),
  // GoRoute(
  //     name: AppRoute.profile.name,
  //     path: AppRoute.profile.path,
  //     builder: (context, state) => const HomeScreen()),
  // GoRoute(
  //     name: AppRoute.activities.name,
  //     path: AppRoute.activities.path,
  //     builder: (context, state) => const HomeScreen()),
  // GoRoute(
  //     name: AppRoute.news.name,
  //     path: AppRoute.news.path,
  //     builder: (context, state) => const HomeScreen()),
  // GoRoute(
  //     name: AppRoute.chat.name,
  //     path: AppRoute.chat.path,
  //     builder: (context, state) => const HomeScreen()),
  // GoRoute(
  //     name: AppRoute.notification.name,
  //     path: AppRoute.notification.path,
  //     builder: (context, state) => const HomeScreen()),
  // GoRoute(
  //     name: AppRoute.report.name,
  //     path: AppRoute.report.path,
  //     builder: (context, state) => const HomeScreen()),
  // GoRoute(
  //     name: AppRoute.settings.name,
  //     path: AppRoute.settings.path,
  //     builder: (context, state) => const HomeScreen()),
];

enum AppRoute {
  home(path: '/', name: 'home'),
  changeRole(path: '/changeRole', name: 'changeRole'),
  login(path: '/login', name: 'login'),
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
    initialLocation: AppRoute.home.path,
    routes: routes,
    redirect: notifier.redirect,
  );
});
