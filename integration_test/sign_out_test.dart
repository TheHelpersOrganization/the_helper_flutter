import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_helper/src/features/authentication/presentation/login_screen.dart';

Future<void> signOut(WidgetTester tester, {bool? skipIfNotAtHome}) async {
  final appBar = find.widgetWithText(AppBar, 'Home');
  if (skipIfNotAtHome != null && skipIfNotAtHome) {
    if (appBar.evaluate().isEmpty) {
      return;
    }
  }
  expect(appBar, findsOneWidget);

  final scaffold = find.byType(Scaffold);
  expect(scaffold, findsOneWidget);

  final scaffoldState = tester.state<ScaffoldState>(scaffold);
  scaffoldState.openDrawer();

  await tester.pumpAndSettle();

  final drawer = find.byType(Drawer);
  expect(drawer, findsOneWidget);

  final logoutEntry = find.widgetWithText(ListTile, 'Logout');
  expect(logoutEntry, findsOneWidget);

  await tester.tap(logoutEntry);

  await tester.pumpAndSettle();

  final signInScreen = find.byType(LoginScreen);
  expect(signInScreen, findsOneWidget);
}
