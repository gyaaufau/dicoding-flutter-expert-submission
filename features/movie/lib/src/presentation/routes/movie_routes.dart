import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../pages/home_movie_page.dart';
import '../pages/movie_detail_page.dart';
import '../pages/popular_movies_page.dart';
import '../pages/search_movie_page.dart';
import '../pages/top_rated_movies_page.dart';

class MovieRouteNames {
  const MovieRouteNames._();

  static const home = 'home';
  static const popular = 'popular';
  static const topRated = 'topRated';
  static const detail = 'movies-detail';
  static const search = 'search';
}

StatefulShellBranch buildMovieBranch() {
  return StatefulShellBranch(
    routes: [
      GoRoute(
        path: HomeMoviePage.ROUTE_NAME,
        name: MovieRouteNames.home,
        builder: (context, state) => AppRouteTrackingScope(
          routeName: state.name ?? MovieRouteNames.home,
          screenName: 'movie_home',
          feature: 'movie',
          contentType: 'movie',
          child: const HomeMoviePage(),
        ),
      ),
    ],
  );
}

List<RouteBase> buildMovieRoutes({required Widget invalidIdPage}) {
  return [
    GoRoute(
      path: PopularMoviesPage.ROUTE_NAME,
      name: MovieRouteNames.popular,
      builder: (context, state) => AppRouteTrackingScope(
        routeName: state.name ?? MovieRouteNames.popular,
        screenName: 'movie_popular',
        feature: 'movie',
        contentType: 'movie',
        child: const PopularMoviesPage(),
      ),
    ),
    GoRoute(
      path: TopRatedMoviesPage.ROUTE_NAME,
      name: MovieRouteNames.topRated,
      builder: (context, state) => AppRouteTrackingScope(
        routeName: state.name ?? MovieRouteNames.topRated,
        screenName: 'movie_top_rated',
        feature: 'movie',
        contentType: 'movie',
        child: const TopRatedMoviesPage(),
      ),
    ),
    GoRoute(
      path: MovieDetailPage.ROUTE_NAME,
      name: MovieRouteNames.detail,
      builder: (context, state) {
        final id = state.extra is int ? state.extra as int : null;
        if (id == null) {
          return invalidIdPage;
        }
        return AppRouteTrackingScope(
          routeName: state.name ?? MovieRouteNames.detail,
          screenName: 'movie_detail',
          feature: 'movie',
          contentType: 'movie',
          contentId: id,
          child: MovieDetailPage(id: id),
        );
      },
    ),
    GoRoute(
      path: SearchMoviePage.ROUTE_NAME,
      name: MovieRouteNames.search,
      builder: (context, state) => AppRouteTrackingScope(
        routeName: state.name ?? MovieRouteNames.search,
        screenName: 'movie_search',
        feature: 'movie',
        contentType: 'movie',
        child: const SearchMoviePage(),
      ),
    ),
  ];
}
