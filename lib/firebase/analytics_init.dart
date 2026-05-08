import 'package:core/core.dart';

Future<void> initializeAnalytics({
  required AnalyticsTracker analyticsTracker,
  required AppInfoProvider appInfoProvider,
}) async {
  await analyticsTracker.setAnalyticsCollectionEnabled(
    shouldEnableAnalyticsCollection(),
  );
  await analyticsTracker.setUserProperty(
    name: 'app_version',
    value: await appInfoProvider.getAppVersion(),
  );
  await analyticsTracker.setUserProperty(
    name: 'build_type',
    value: appInfoProvider.getBuildType(),
  );
}
