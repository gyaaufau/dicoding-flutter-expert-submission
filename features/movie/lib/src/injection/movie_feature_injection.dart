import 'package:dependencies/dependencies.dart';

import '../presentation/cubit/movie_detail_cubit.dart';
import '../presentation/cubit/movie_list_cubit.dart';
import '../presentation/cubit/movie_search_cubit.dart';
import '../presentation/cubit/popular_movies_cubit.dart';
import '../presentation/cubit/top_rated_movies_cubit.dart';
import '../presentation/cubit/watchlist_movie_cubit.dart';

void registerMovieFeatureDependencies(GetIt locator) {
  locator.registerFactory(
    () => MovieListCubit(
      getNowPlayingMovies: locator(),
      getPopularMovies: locator(),
      getTopRatedMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieDetailCubit(
      getMovieDetail: locator(),
      getMovieRecommendations: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );
  locator.registerFactory(() => MovieSearchCubit(searchMovies: locator()));
  locator.registerFactory(() => PopularMoviesCubit(locator()));
  locator.registerFactory(
    () => TopRatedMoviesCubit(getTopRatedMovies: locator()),
  );
  locator.registerFactory(
    () => WatchlistMovieCubit(getWatchlistMovies: locator()),
  );
}
