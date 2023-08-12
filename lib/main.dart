import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:the_helper/src/app.dart';

void main() {
  // Remove # in web app url. a.k.a localhost/#/home -> localhost/home
  // if (kIsWeb) {
  //   usePathUrlStrategy();
  // }
  WidgetsFlutterBinding.ensureInitialized();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  runApp(const ProviderScope(child: MyApp()));
}
