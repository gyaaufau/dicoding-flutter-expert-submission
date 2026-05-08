import 'package:core/src/network/ssl-pinning-network.dart';
import 'package:dependencies/dependencies.dart' as dep;

import '../analytics/analytics_tracker.dart';
import '../analytics/app_info_provider.dart';
import '../crashlytics/app_bloc_observer.dart';
import '../crashlytics/crash_reporter.dart';
import '../network/network_info.dart';
import 'locator.dart';

Future<void> registerCoreDependencies({dep.Client? sslPinningClient}) async {
  locator.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(locator()));

  final pinnedClient = sslPinningClient ?? await SslPinningHttpClient.create();
  locator.registerLazySingleton(() => pinnedClient);

  locator.registerLazySingleton(() => dep.DataConnectionChecker());
  locator.registerLazySingleton<AppInfoProvider>(
    () => PackageAppInfoProvider(),
  );
  locator.registerLazySingleton<AnalyticsTracker>(
    () => FirebaseAnalyticsTracker(),
  );
  locator.registerLazySingleton<CrashReporter>(() => FirebaseCrashReporter());
  locator.registerLazySingleton(() => AppBlocObserver(locator()));
}
