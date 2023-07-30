import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_helper/src/common/widget/label.dart';
import 'package:the_helper/src/features/activity/presentation/activity_detail/widget/shift_action_dialog/join_shift_dialog.dart';
import 'package:the_helper/src/features/activity/presentation/activity_detail/widget/shift_card/shift_card.dart';
import 'package:the_helper/src/features/activity/presentation/search/screen/activity_search_screen.dart';
import 'package:the_helper/src/features/activity/presentation/search/widget/activity_card/activity_card.dart';
import 'package:the_helper/src/features/shift/presentation/shift/widget/shift_bottom_bar.dart';

import 'utils.dart';

Future<void> searchActivities(WidgetTester tester) async {
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

  final activitiesSearchEntry = find.widgetWithText(ListTile, 'Activities');
  expect(activitiesSearchEntry, findsOneWidget);

  await tester.tap(activitiesSearchEntry);

  await tester.pumpAndSettle();

  final activitySearchScreen = find.byType(ActivitySearchScreen);
  expect(activitySearchScreen, findsOneWidget);

  final activitySearchAppBar = find.widgetWithText(AppBar, 'Search Activities');
  expect(activitySearchAppBar, findsOneWidget);

  final searchIconButton = find.ancestor(
    of: find.byIcon(Icons.search_outlined),
    matching: find.byType(IconButton),
  );
  expect(searchIconButton, findsOneWidget);

  await tester.tap(searchIconButton);

  await tester.pumpAndSettle();

  final searchField = find.byType(TextField);
  expect(searchField, findsOneWidget);

  await tester.enterText(searchField, 'a');

  final searchLabel = find.textContaining('Search results for "a"');
  await tester.pumpUntilFound(searchLabel);
  expect(searchLabel, findsOneWidget);

  await tester.pumpAndSettle();

  final activityItem = find.byType(ActivityCard);
  expect(activityItem, findsWidgets);

  await tester.tap(activityItem.first);

  await tester.pumpAndSettle();

  final shiftTab = find.widgetWithText(Tab, 'Shifts');
  expect(shiftTab, findsOneWidget);

  await tester.tap(shiftTab);

  await tester.pumpAndSettle();

  final shiftItem = find.ancestor(
    of: find.widgetWithText(FilledButton, 'Join'),
    matching: find.ancestor(
      of: find.widgetWithText(Label, 'Upcoming'),
      matching: find.byType(ShiftCard),
    ),
  );
  expect(shiftItem, findsWidgets);

  await tester.dragUntilVisible(
    shiftItem.first,
    find.byKey(
      const Key('activity_detail_screen_scroll_view'),
    ),
    const Offset(-100, 0),
  );

  await tester.tap(shiftItem.first);

  await tester.pumpAndSettle();

  final shiftBottomBar = find.byType(ShiftBottomBar);
  await tester.pumpUntilFound(shiftBottomBar);
  expect(shiftBottomBar, findsOneWidget);

  final joinButton = find.widgetWithText(FilledButton, 'Join');
  expect(joinButton, findsOneWidget);

  await tester.tap(joinButton);

  await tester.pumpAndSettle();

  final joinShiftDialog = find.byType(JoinShiftDialog);
  expect(joinShiftDialog, findsOneWidget);

  final joinShiftButton = find.descendant(
    of: joinShiftDialog,
    matching: find.widgetWithText(FilledButton, 'Join'),
  );
  expect(joinShiftButton, findsOneWidget);

  await tester.tap(joinShiftButton);

  await tester.pumpAndSettle();

  final snackBar = find.byType(SnackBar);
  expect(snackBar, findsOneWidget);

  await tester.pumpAndSettle();

  await tester.pump(const Duration(seconds: 5));
}
