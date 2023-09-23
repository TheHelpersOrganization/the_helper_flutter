
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_helper/src/common/widget/bottom_sheet/custom_modal_botton_sheet.dart';
import 'package:the_helper/src/common/widget/label.dart';
import 'package:the_helper/src/features/activity/presentation/admin_manage/screens/activity_manage_screen.dart';
import 'package:the_helper/src/features/activity/presentation/admin_manage/widgets/activity_list_item.dart';

Future<void> unbanActivity(WidgetTester tester) async {
  // home
  final scaffold = find.byType(Scaffold);
  expect(scaffold, findsOneWidget);

  // admin role
  final appBar = find.widgetWithText(AppBar, 'Home');
  expect(appBar, findsOneWidget);

  final adminTag = find.widgetWithText(Label, 'Admin');
  expect(adminTag, findsOneWidget);

  // open drawer
  final scaffoldState = tester.state<ScaffoldState>(scaffold);
  scaffoldState.openDrawer();
  await tester.pumpAndSettle();
  final drawer = find.byType(Drawer);
  expect(drawer, findsOneWidget);

  // choose activity manage
  final activitiesManageOption =
      find.widgetWithText(ListTile, 'Activities manage');
  await tester.dragUntilVisible(
      activitiesManageOption, drawer, const Offset(0, -500));
  await tester.pump();
  expect(activitiesManageOption, findsOneWidget);
  await tester.tap(activitiesManageOption);
  await tester.pumpAndSettle();

  // show activity manage screen
  final activitiesManageScreen = find.byType(AdminActivityManageScreen);
  expect(activitiesManageScreen, findsOneWidget);
  final activityItem = find.byType(ActivityListItem);
  expect(activityItem, findsWidgets);

  // filter active activity
  final filterChip = find.widgetWithText(FilterChip, 'Banned');
  expect(filterChip, findsOneWidget);

  await tester.tap(filterChip);
  await tester.pumpAndSettle();

  // choose an activity
  final newActivityItem = find.byType(ActivityListItem);
  expect(newActivityItem, findsWidgets);
  Text choosenItem = tester.firstWidget(find.descendant(
      of: find.byType(ActivityListItem), matching: find.byType(Text)));

  await tester.tap(newActivityItem.first);

  await tester.pumpAndSettle();
  final modalBottom = find.byType(CustomModalBottomSheet);
  expect(modalBottom, findsOneWidget);

  // choose ban in option sheet
  final unbanOption = find.widgetWithText(ListTile, 'Unbanned activity');
  expect(unbanOption, findsOneWidget);

  await tester.tap(unbanOption);
  await tester.pumpAndSettle();

  // filter banned activity
  final filterunbannedChip = find.widgetWithText(FilterChip, 'Active');
  expect(filterunbannedChip, findsOneWidget);

  await tester.tap(filterunbannedChip);
  await tester.pumpAndSettle();
  
  // see the same activity in the list
  final unbannedActivity = find.widgetWithText(ActivityListItem, choosenItem.data.toString());
  await tester.dragUntilVisible(
      unbannedActivity, activitiesManageScreen, const Offset(0, -500));
  await tester.pump();
  expect(unbannedActivity, findsOneWidget);
}
