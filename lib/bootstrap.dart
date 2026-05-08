import 'dart:async';

import 'package:ditonton/app.dart';
import 'package:ditonton/firebase/analytics_init.dart';
import 'package:ditonton/firebase/crashlytic_init.dart';
import 'package:ditonton/firebase/firebase_init.dart';
import 'package:ditonton/injection.dart';
import 'package:core/core.dart';
import 'package:dependencies/dependencies.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

Future<void> bootstrap() async {
  await runZonedGuarded(
    () async {
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

      runApp(const MyApp());
    },
    (error, stackTrace) {
      if (locator.isRegistered<CrashReporter>()) {
        final crashReporter = locator<CrashReporter>();
        unawaited(
          crashReporter.recordFatal(
            error,
            stackTrace,
            reason: 'run_zoned_guarded_error',
          ),
        );
        return;
      }

      debugPrint('Unhandled bootstrap error: $error');
      debugPrintStack(stackTrace: stackTrace);
    },
  );
}
