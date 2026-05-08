import 'package:dependencies/dependencies.dart';

import '../data/datasources/tv_database_helper.dart';
import '../data/datasources/tv_local_data_source.dart';
import '../data/datasources/tv_remote_data_source.dart';
import '../data/repositories/tv_repository_impl.dart';
import '../domain/repositories/tv_repository.dart';
import '../domain/usecases/get_on_the_air_tv.dart';
import '../domain/usecases/get_popular_tv.dart';
import '../domain/usecases/get_top_rated_tv.dart';
import '../domain/usecases/get_tv_detail.dart';
import '../domain/usecases/get_tv_recommendations.dart';
import '../domain/usecases/get_tv_season_detail.dart';
import '../domain/usecases/get_watchlist_tv.dart';
import '../domain/usecases/get_watchlist_tv_status.dart';
import '../domain/usecases/remove_watchlist_tv.dart';
import '../domain/usecases/save_watchlist_tv.dart';
import '../domain/usecases/search_tv.dart';

void registerTvDomainDependencies(GetIt locator) {
  locator.registerLazySingleton<TvRemoteDataSource>(
    () => TvRemoteDataSourceImpl(client: locator()),
  );
  locator.registerLazySingleton<TvLocalDataSource>(
    () => TvLocalDataSourceImpl(databaseHelper: locator()),
  );
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());
  locator.registerLazySingleton<TvRepository>(
    () => TvRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
      crashReporter: locator(),
    ),
  );

  locator.registerLazySingleton(() => GetOnTheAirTv(locator()));
  locator.registerLazySingleton(() => GetPopularTv(locator()));
  locator.registerLazySingleton(() => GetTopRatedTv(locator()));
  locator.registerLazySingleton(() => GetTvDetail(locator()));
  locator.registerLazySingleton(() => GetTvSeasonDetail(locator()));
  locator.registerLazySingleton(() => GetTvRecommendations(locator()));
  locator.registerLazySingleton(() => SearchTv(locator()));
  locator.registerLazySingleton(() => GetWatchlistTv(locator()));
  locator.registerLazySingleton(() => GetWatchlistTvStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlistTv(locator()));
  locator.registerLazySingleton(() => RemoveWatchlistTv(locator()));
}
