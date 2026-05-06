import 'package:core/core.dart';
import 'package:dependencies/dependencies.dart';

import '../data/datasources/movie_database_helper.dart';
import '../data/datasources/movie_local_data_source.dart';
import '../data/datasources/movie_remote_data_source.dart';
import '../data/repositories/movie_repository_impl.dart';
import '../domain/repositories/movie_repository.dart';
import '../domain/usecases/get_movie_detail.dart';
import '../domain/usecases/get_movie_recommendations.dart';
import '../domain/usecases/get_now_playing_movies.dart';
import '../domain/usecases/get_popular_movies.dart';
import '../domain/usecases/get_top_rated_movies.dart';
import '../domain/usecases/get_watchlist_movies.dart';
import '../domain/usecases/get_watchlist_status.dart';
import '../domain/usecases/remove_watchlist.dart';
import '../domain/usecases/save_watchlist.dart';
import '../domain/usecases/search_movies.dart';

void registerMovieDomainDependencies(GetIt locator) {
  locator.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(client: locator()),
  );
  locator.registerLazySingleton<MovieLocalDataSource>(
    () => MovieLocalDataSourceImpl(databaseHelper: locator()),
  );
  locator.registerLazySingleton<MovieDatabaseHelper>(
    () => MovieDatabaseHelper(),
  );
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
      networkInfo: locator<NetworkInfo>(),
    ),
  );

  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));
}
