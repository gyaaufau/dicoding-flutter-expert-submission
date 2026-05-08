import 'package:dependencies/dependencies.dart';

import 'analytics_tracker.dart';

abstract class AppInfoProvider {
  Future<String> getAppVersion();

  String getBuildType();
}

class PackageAppInfoProvider implements AppInfoProvider {
  @override
  Future<String> getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    if (packageInfo.buildNumber.isEmpty) {
      return packageInfo.version;
    }
    return '${packageInfo.version}+${packageInfo.buildNumber}';
  }

  @override
  String getBuildType() => currentBuildType();
}
