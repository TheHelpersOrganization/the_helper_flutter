import 'package:flutter/material.dart';
import 'package:simple_auth_flutter_riverpod/src/features/authentication/presentation/auth_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: AuthScreen(),
    );
  }
}
