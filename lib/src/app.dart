import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_auth_flutter_riverpod/src/features/authentication/presentation/auth_screen.dart';
import 'package:simple_auth_flutter_riverpod/src/features/change_role/presentation/change_role_screen.dart';
import 'package:simple_auth_flutter_riverpod/src/features/change_role/presentation/home_screen.dart';

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: 'change_role',
      builder: (context, state) => const ChangeRoleScreen(),
    ),
    GoRoute(
      path: '/home/:role',
      name: 'homescreen',
      builder: (context, state) => HomeScreen(
        role: state.params['role']!,
      )
    )
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
    );
  }
}
