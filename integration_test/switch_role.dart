import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_helper/src/features/change_role/presentation/screens/change_role_screen.dart';
import 'package:the_helper/src/features/change_role/presentation/widgets/role_option.dart';

Future<void> switchRole(WidgetTester tester) async {
  // From home
  final scaffold = find.byType(Scaffold);
  expect(scaffold, findsOneWidget);

  final appBar = find.widgetWithText(AppBar, 'Home');
  expect(appBar, findsOneWidget);

  final scaffoldState = tester.state<ScaffoldState>(scaffold);
  scaffoldState.openDrawer();

  await tester.pumpAndSettle();

  final drawer = find.byType(Drawer);
  expect(drawer, findsOneWidget);

  final changeRoleEntry = find.widgetWithText(ListTile, 'Change Role');
  await tester.dragUntilVisible(changeRoleEntry, drawer, const Offset(0, -500));
  await tester.pump();
  expect(changeRoleEntry, findsOneWidget);

  await tester.tap(changeRoleEntry);

  await tester.pumpAndSettle();

  final changeRoleScreen = find.byType(ChangeRoleScreen);
  expect(changeRoleScreen, findsOneWidget);

  final adminOption = find.widgetWithText(RoleOption, 'Admin');
  expect(adminOption, findsOneWidget);

  await tester.tap(adminOption);
  await tester.pumpAndSettle();

  final adminAppBar = find.widgetWithText(AppBar, 'Admin');
  expect(adminAppBar, findsOneWidget);
}
