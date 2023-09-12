import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:the_helper/main.dart' as app;

import 'switch_role.dart';
import 'sign_in_test.dart';
import 'ban_activity.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // group('end-to-end test', () {
  //   testWidgets('search activities', (tester) async {
  //     app.main();
  //     await tester.pumpAndSettle();
  //     await signIn(tester);
  //     await searchActivities(tester);
  //   });
  // });

  group('admin-activities test', () {
    testWidgets('ban activity', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      await signIn(tester);
      await switchRole(tester);
      // await banActivity(tester);
    });
  });
}
