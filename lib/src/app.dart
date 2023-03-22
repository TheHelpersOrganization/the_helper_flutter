import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import './router/router.dart';

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'The Helper',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: ThemeData(
          useMaterial3: true, colorSchemeSeed: const Color(0xFF254687)),
    );
  }
}
