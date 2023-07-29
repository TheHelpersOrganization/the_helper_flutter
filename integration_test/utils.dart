import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

extension WidgetTesterX on WidgetTester {
  pumpUntilFound(
    Finder finder, {
    Duration timeout = const Duration(seconds: 10),
  }) async {
    bool timerDone = false;
    final timer = Timer(timeout, () => timerDone = true);
    while (timerDone != true) {
      await pump();

      final found = any(finder);
      if (found) {
        timerDone = true;
      }
    }
    timer.cancel();
  }
}

void onErrorIgnoreOverflowErrors(
  FlutterErrorDetails details, {
  bool forceReport = false,
}) {
  bool ifIsOverflowError = false;

  // Detect overflow error.
  var exception = details.exception;
  if (exception is FlutterError) {
    ifIsOverflowError = !exception.diagnostics.any(
        (e) => e.value.toString().startsWith("A RenderFlex overflowed by"));
  }

  // Ignore if is overflow error.
  if (ifIsOverflowError) {
    print('Overflow error.');
  } else {
    FlutterError.dumpErrorToConsole(details, forceReport: forceReport);
  }
}

void ignoreOverflowErrors() {
  FlutterError.onError = onErrorIgnoreOverflowErrors;
}

Future<void> ignoreOverflowErrorsAndThenRestoreFlutterError(
    Future<void> Function() call) async {
  final originalOnError = FlutterError.onError!;
  ignoreOverflowErrors();
  await call();
  final overriddenOnError = FlutterError.onError!;

  // restore FlutterError.onError
  FlutterError.onError = (FlutterErrorDetails details) {
    if (overriddenOnError != originalOnError) overriddenOnError(details);
    originalOnError(details);
  };
}
