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
        builder: (context, state) => const HomeMoviePage(),
      ),
    ],
  );
}

List<RouteBase> buildMovieRoutes({required Widget invalidIdPage}) {
  return [
    GoRoute(
      path: PopularMoviesPage.ROUTE_NAME,
      name: MovieRouteNames.popular,
      builder: (context, state) => const PopularMoviesPage(),
    ),
    GoRoute(
      path: TopRatedMoviesPage.ROUTE_NAME,
      name: MovieRouteNames.topRated,
      builder: (context, state) => const TopRatedMoviesPage(),
    ),
    GoRoute(
      path: MovieDetailPage.ROUTE_NAME,
      name: MovieRouteNames.detail,
      builder: (context, state) {
        final id = state.extra is int ? state.extra as int : null;
        if (id == null) {
          return invalidIdPage;
        }
        return MovieDetailPage(id: id);
      },
    ),
    GoRoute(
      path: SearchMoviePage.ROUTE_NAME,
      name: MovieRouteNames.search,
      builder: (context, state) => const SearchMoviePage(),
    ),
  ];
}
