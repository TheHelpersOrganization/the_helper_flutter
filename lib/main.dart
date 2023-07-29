import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/app.dart';

void main() {
  // Remove # in web app url. a.k.a localhost/#/home -> localhost/home
  // if (kIsWeb) {
  //   usePathUrlStrategy();
  // }
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}
