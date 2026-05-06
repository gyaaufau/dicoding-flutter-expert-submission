import 'package:dependencies/dependencies.dart';

import '../presentation/cubit/tv_detail_cubit.dart';
import '../presentation/cubit/tv_list_cubit.dart';
import '../presentation/cubit/tv_search_cubit.dart';
import '../presentation/cubit/watchlist_tv_cubit.dart';

void registerTvFeatureDependencies(GetIt locator) {
  locator.registerFactory(
    () => TvListCubit(
      getOnTheAirTvUseCase: locator(),
      getPopularTvUseCase: locator(),
      getTopRatedTvUseCase: locator(),
    ),
  );
  locator.registerFactory(
    () => TvDetailCubit(
      getTvSeasonDetail: locator(),
      getTvDetail: locator(),
      getTvRecommendations: locator(),
    ),
  );
  locator.registerFactory(
    () => WatchlistTvCubit(
      getWatchlistTv: locator(),
      getWatchlistTvStatus: locator(),
      saveWatchlistTv: locator(),
      removeWatchlistTv: locator(),
    ),
  );
  locator.registerFactory(() => TvSearchCubit(searchTv: locator()));
}
