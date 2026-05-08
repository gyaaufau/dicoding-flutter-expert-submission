import 'package:common/common.dart';
import 'package:core/core.dart';
import 'package:movie/movie.dart';
import 'package:profile/profile.dart';
import 'package:tv/tv.dart';
import 'package:watchlist/watchlist.dart';

final appRouter = buildAppRouter(
  initialLocation: HomeMoviePage.ROUTE_NAME,
  observer: routeObserver,
  errorPage: const AppNotFoundPage(),
  shellBuilder: (context, state, navigationShell) => AppRouteTrackingScope(
    routeName: state.name ?? 'shell',
    screenName: 'main_shell',
    feature: 'shell',
    trackScreenView: false,
    child: MainShellPage(navigationShell: navigationShell),
  ),
  branches: [
    buildMovieBranch(),
    buildTvBranch(),
    buildWatchlistBranch(),
    buildProfileBranch(),
  ],
  routes: [
    ...buildMovieRoutes(invalidIdPage: const AppNotFoundPage()),
    ...buildTvRoutes(invalidIdPage: const AppNotFoundPage()),
    ...buildProfileRoutes(),
  ],
);
