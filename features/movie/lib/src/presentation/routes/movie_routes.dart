import 'package:common/common.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../cubit/movie_detail_cubit.dart';
import '../cubit/movie_list_cubit.dart';
import '../cubit/movie_search_cubit.dart';
import '../cubit/popular_movies_cubit.dart';
import '../cubit/top_rated_movies_cubit.dart';
import '../cubit/watchlist_movie_cubit.dart';
import '../pages/home_movie_page.dart';
import '../pages/movie_detail_page.dart';
import '../pages/popular_movies_page.dart';
import '../pages/search_movie_page.dart';
import '../pages/top_rated_movies_page.dart';

class MovieRouteNames {
  const MovieRouteNames._();

  static const home = AppRouteNames.moviesHome;
  static const popular = AppRouteNames.moviesPopular;
  static const topRated = AppRouteNames.moviesTopRated;
  static const detail = AppRouteNames.moviesDetail;
  static const search = AppRouteNames.moviesSearch;
}

StatefulShellBranch buildMovieBranch() {
  return StatefulShellBranch(
    routes: [
      GoRoute(
        path: AppRoutePaths.movies,
        name: MovieRouteNames.home,
        builder: (context, state) => BlocProvider(
          create: (_) => locator<MovieListCubit>(),
          child: AppRouteTrackingScope(
            routeName: state.name ?? MovieRouteNames.home,
            screenName: 'movie_home',
            feature: 'movie',
            contentType: 'movie',
            child: const HomeMoviePage(),
          ),
        ),
      ),
    ],
  );
}

List<RouteBase> buildMovieRoutes({
  required Widget invalidIdPage,
  GlobalKey<NavigatorState>? parentNavigatorKey,
}) {
  return [
    GoRoute(
      parentNavigatorKey: parentNavigatorKey,
      path: AppRoutePaths.moviesPopular,
      name: MovieRouteNames.popular,
      builder: (context, state) => BlocProvider(
        create: (_) => locator<PopularMoviesCubit>(),
        child: AppRouteTrackingScope(
          routeName: state.name ?? MovieRouteNames.popular,
          screenName: 'movie_popular',
          feature: 'movie',
          contentType: 'movie',
          child: const PopularMoviesPage(),
        ),
      ),
    ),
    GoRoute(
      parentNavigatorKey: parentNavigatorKey,
      path: AppRoutePaths.moviesTopRated,
      name: MovieRouteNames.topRated,
      builder: (context, state) => BlocProvider(
        create: (_) => locator<TopRatedMoviesCubit>(),
        child: AppRouteTrackingScope(
          routeName: state.name ?? MovieRouteNames.topRated,
          screenName: 'movie_top_rated',
          feature: 'movie',
          contentType: 'movie',
          child: const TopRatedMoviesPage(),
        ),
      ),
    ),
    GoRoute(
      parentNavigatorKey: parentNavigatorKey,
      path: AppRoutePaths.moviesSearch,
      name: MovieRouteNames.search,
      builder: (context, state) => BlocProvider(
        create: (_) => locator<MovieSearchCubit>(),
        child: AppRouteTrackingScope(
          routeName: state.name ?? MovieRouteNames.search,
          screenName: 'movie_search',
          feature: 'movie',
          contentType: 'movie',
          child: const SearchMoviePage(),
        ),
      ),
    ),
    GoRoute(
      parentNavigatorKey: parentNavigatorKey,
      path: AppRoutePaths.moviesDetailPattern,
      name: MovieRouteNames.detail,
      builder: (context, state) {
        final id = int.tryParse(
          state.pathParameters[AppRouteParams.id] ?? '',
        );
        if (id == null) {
          return invalidIdPage;
        }
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => locator<MovieDetailCubit>()),
            BlocProvider(create: (_) => locator<WatchlistMovieCubit>()),
          ],
          child: AppRouteTrackingScope(
            routeName: state.name ?? MovieRouteNames.detail,
            screenName: 'movie_detail',
            feature: 'movie',
            contentType: 'movie',
            contentId: id,
            child: MovieDetailPage(id: id),
          ),
        );
      },
    ),
  ];
}
