import 'package:common/common.dart';
import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movie/movie.dart';
import 'package:tv/tv.dart';

import '../pages/watchlist_movies_page.dart';

class WatchlistRouteNames {
  const WatchlistRouteNames._();

  static const home = AppRouteNames.watchlist;
}

StatefulShellBranch buildWatchlistBranch() {
  return StatefulShellBranch(
    routes: [
      GoRoute(
        path: AppRoutePaths.watchlist,
        name: WatchlistRouteNames.home,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => locator<WatchlistMovieCubit>()),
            BlocProvider(create: (_) => locator<WatchlistTvCubit>()),
          ],
          child: AppRouteTrackingScope(
            routeName: state.name ?? WatchlistRouteNames.home,
            screenName: 'watchlist_home',
            feature: 'watchlist',
            contentType: 'watchlist',
            child: const WatchlistMoviesPage(),
          ),
        ),
      ),
    ],
  );
}
