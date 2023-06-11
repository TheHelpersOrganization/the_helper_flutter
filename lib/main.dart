import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:the_helper/src/app.dart';

void main() {
  // Remove # in web app url. a.k.a localhost/#/home -> localhost/home
  usePathUrlStrategy();
  runApp(const ProviderScope(child: MyApp()));
}
