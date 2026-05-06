import 'package:dependencies/dependencies.dart' as dep;

import 'locator.dart';
import 'network_info.dart';

void registerCoreDependencies() {
  locator.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(locator()));
  locator.registerLazySingleton(() => dep.Client());
  locator.registerLazySingleton(() => dep.DataConnectionChecker());
}
