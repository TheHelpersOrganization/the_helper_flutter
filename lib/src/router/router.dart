import 'package:go_router/go_router.dart';
import 'package:simple_auth_flutter_riverpod/src/features/authentication/presentation/auth_screen.dart';
import 'package:simple_auth_flutter_riverpod/src/features/change_role/presentation/home_screen.dart';

final router = GoRouter(routes: [
  GoRoute(
    path: Routes.home,
    builder: (context, state) => const HomeScreen(),
  ),
  GoRoute(path: Routes.login, builder: (context, state) => const AuthScreen()),
  GoRoute(
      path: Routes.profile, builder: (context, state) => const HomeScreen()),
  GoRoute(
      path: Routes.activities, builder: (context, state) => const HomeScreen()),
  GoRoute(path: Routes.news, builder: (context, state) => const AuthScreen()),
  GoRoute(path: Routes.chat, builder: (context, state) => const AuthScreen()),
  GoRoute(
      path: Routes.notification,
      builder: (context, state) => const AuthScreen()),
  GoRoute(path: Routes.report, builder: (context, state) => const AuthScreen()),
  GoRoute(
      path: Routes.settings, builder: (context, state) => const AuthScreen()),
]);

class Routes {
  static const home = '/';
  static const login = '/login';
  static const profile = '/profile';
  static const activities = '/activities';
  static const news = '/news';
  static const chat = '/chat';
  static const notification = '/notification';
  static const report = '/report';
  static const settings = '/settings';
}
