import 'package:common/common.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:movie/movie.dart';
import 'package:profile/profile.dart';
import 'package:tv/tv.dart';
import 'package:watchlist/watchlist.dart';

import 'app_routes.dart';

final appRootNavigatorKey = GlobalKey<NavigatorState>();

bool _showsShellNavigation(String path) {
  return switch (path) {
    AppRoutePaths.movies ||
    AppRoutePaths.tv ||
    AppRoutePaths.watchlist ||
    AppRoutePaths.profile => true,
    _ => false,
  };
}

final appRouter = buildAppRouter(
  initialLocation: AppRoutePaths.movies,
  observer: routeObserver,
  errorPage: const AppNotFoundPage(),
  navigatorKey: appRootNavigatorKey,
  shellBuilder: (context, state, navigationShell) {
    final shellChild = AppRouteTrackingScope(
      routeName: state.name ?? 'shell',
      screenName: 'main_shell',
      feature: 'shell',
      trackScreenView: false,
      child: navigationShell,
    );

    if (!_showsShellNavigation(state.uri.path)) {
      return shellChild;
    }

    return MainShellPage(navigationShell: navigationShell);
  },
  branches: [
    buildMovieBranch(),
    buildTvBranch(),
    buildWatchlistBranch(),
    buildProfileBranch(),
  ],
  routes: [
    ...buildMovieRoutes(
      invalidIdPage: const AppNotFoundPage(),
      parentNavigatorKey: appRootNavigatorKey,
    ),
    ...buildTvRoutes(
      invalidIdPage: const AppNotFoundPage(),
      parentNavigatorKey: appRootNavigatorKey,
    ),
    ...buildProfileRoutes(parentNavigatorKey: appRootNavigatorKey),
  ],
);
