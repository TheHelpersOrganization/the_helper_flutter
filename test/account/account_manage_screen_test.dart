import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_helper/src/features/account/presentation/account_admin_manage/screens/account_manage_screen.dart';

void main() {

  Widget createTestableWidget(Widget child) {
    return ProviderScope(
      // overrides: [
      //   mockRepositoryProvider.overrideWithValue(MockRepository())
      // ],
      child: MaterialApp(
        home: child,
      ),
    );
  }

  testWidgets('title is display', (WidgetTester tester) async {
    await tester.pumpWidget(createTestableWidget(AccountManageScreen()));
    await tester.pump(Duration(seconds: 3));

    expect(find.text('Accounts manage'), findsOneWidget);
  });
}
