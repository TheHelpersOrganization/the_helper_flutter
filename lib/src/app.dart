import 'package:flutter/material.dart';
import 'package:simple_auth_flutter_riverpod/src/features/authentication/presentation/auth_screen.dart';
import 'package:simple_auth_flutter_riverpod/src/features/change_role/presentation/change_role_screen.dart';
import 'package:simple_auth_flutter_riverpod/src/features/change_role/presentation/home_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: ChangeRoleScreen(),
      //home: HomeScreen(),
      //home: AuthScreen(),
    );
  }
}
