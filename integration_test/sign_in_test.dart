import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> signIn(WidgetTester tester) async {
  expect(find.textContaining('Welcome'), findsOneWidget);
  expect(find.textContaining('Sign in'), findsOneWidget);

  final emailField = find.ancestor(
    of: find.textContaining('email'),
    matching: find.byType(TextFormField),
  );
  expect(emailField, findsOneWidget);

  final passwordField = find.ancestor(
    of: find.textContaining('password'),
    matching: find.byType(TextFormField),
  );
  expect(passwordField, findsOneWidget);

  await tester.enterText(emailField, 'hquan310@gmail.com');
  await tester.enterText(passwordField, '123456');

  final signInButton = find.ancestor(
    of: find.textContaining('Sign In'),
    matching: find.byType(FilledButton),
  );
  expect(signInButton, findsOneWidget);

  await tester.tap(signInButton);

  // Wait for the user to be redirected to the home screen.
  await tester.pumpAndSettle();

  final scaffold = find.byType(Scaffold);
  expect(scaffold, findsOneWidget);

  final appBar = find.widgetWithText(AppBar, 'Home');
  expect(appBar, findsOneWidget);
}
