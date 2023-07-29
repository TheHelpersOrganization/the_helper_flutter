import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:the_helper/main.dart' as app;

import 'search_activities.dart';
import 'sign_in_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    // testWidgets('sign in with email and password', (tester) async {
    //   app.main();
    //   await tester.pumpAndSettle();
    //   await signIn(tester);
    // });

    testWidgets('search activities', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      await signIn(tester);
      await searchActivities(tester);
    });
  });
}