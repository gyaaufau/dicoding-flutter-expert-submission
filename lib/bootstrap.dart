import 'dart:async';

import 'package:ditonton/app.dart';
import 'package:ditonton/firebase/analytics_init.dart';
import 'package:ditonton/firebase/crashlytic_init.dart';
import 'package:ditonton/firebase/firebase_init.dart';
import 'package:ditonton/injection.dart';
import 'package:core/core.dart';
import 'package:dependencies/dependencies.dart';
import 'package:flutter/widgets.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebase();
  await AppInjection.init();

  final analyticsTracker = locator<AnalyticsTracker>();
  final appInfoProvider = locator<AppInfoProvider>();
  final crashReporter = locator<CrashReporter>();
  Bloc.observer = locator<AppBlocObserver>();

  await initializeAnalytics(
    analyticsTracker: analyticsTracker,
    appInfoProvider: appInfoProvider,
  );
  await initializeCrashlytics(crashReporter: crashReporter);

  await runZonedGuarded(
    () async {
      runApp(const MyApp());
    },
    (error, stackTrace) {
      unawaited(
        crashReporter.recordFatal(
          error,
          stackTrace,
          reason: 'run_zoned_guarded_error',
        ),
      );
    },
  );
}
