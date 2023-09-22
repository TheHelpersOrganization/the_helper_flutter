import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:the_helper/main.dart' as app;

import 'ban_activity.dart';
import 'search_activities.dart';
import 'sign_in_test.dart';
import 'sign_out_test.dart';
import 'switch_role.dart';
import 'unban_activity.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  // Allow entering text in profile mode.
  binding.testTextInput.register();

  group('end-to-end test', () {
    testWidgets('search activities', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      await signOut(tester, skipIfNotAtHome: true);
      await signIn(tester);
      await searchActivities(tester);
    });
  });

  group('admin-activities test', () {
    testWidgets('ban activity', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      await signIn(tester);
      await switchRole(tester);
      await banActivity(tester);
    });
    testWidgets('unban activity', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      await signIn(tester);
      await switchRole(tester);
      await unbanActivity(tester);
    });
  });
}
