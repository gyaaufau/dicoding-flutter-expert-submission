import 'dart:ui';

import 'package:core/core.dart';
import 'package:flutter/widgets.dart';

Future<void> initializeCrashlytics({
  required CrashReporter crashReporter,
}) async {
  await crashReporter.setCollectionEnabled(
    shouldEnableCrashlyticsCollection(),
  );

  FlutterError.onError = crashReporter.recordFlutterFatalError;

  PlatformDispatcher.instance.onError = (error, stack) {
    crashReporter.recordFatal(
      error,
      stack,
      reason: 'platform_dispatcher_error',
    );
    return true;
  };
}
