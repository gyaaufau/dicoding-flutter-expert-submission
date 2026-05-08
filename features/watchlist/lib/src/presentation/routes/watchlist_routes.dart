import 'package:core/core.dart';
import 'package:go_router/go_router.dart';

import '../pages/watchlist_movies_page.dart';

class WatchlistRouteNames {
  const WatchlistRouteNames._();

  static const home = 'watchlist';
}

StatefulShellBranch buildWatchlistBranch() {
  return StatefulShellBranch(
    routes: [
      GoRoute(
        path: WatchlistMoviesPage.ROUTE_NAME,
        name: WatchlistRouteNames.home,
        builder: (context, state) => AppRouteTrackingScope(
          routeName: state.name ?? WatchlistRouteNames.home,
          screenName: 'watchlist_home',
          feature: 'watchlist',
          contentType: 'watchlist',
          child: const WatchlistMoviesPage(),
        ),
      ),
    ],
  );
}
