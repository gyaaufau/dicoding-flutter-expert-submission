import 'package:common/common.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../cubit/tv_detail_cubit.dart';
import '../cubit/tv_list_cubit.dart';
import '../cubit/tv_search_cubit.dart';
import '../cubit/watchlist_tv_cubit.dart';
import '../pages/popular_tv_page.dart';
import '../pages/search_tv_page.dart';
import '../pages/top_rated_tv_page.dart';
import '../pages/tv_detail_page.dart';
import '../pages/tv_page.dart';

class TvRouteNames {
  const TvRouteNames._();

  static const home = AppRouteNames.tvHome;
  static const popular = AppRouteNames.tvPopular;
  static const topRated = AppRouteNames.tvTopRated;
  static const detail = AppRouteNames.tvDetail;
  static const search = AppRouteNames.tvSearch;
}

StatefulShellBranch buildTvBranch() {
  return StatefulShellBranch(
    routes: [
      GoRoute(
        path: AppRoutePaths.tv,
        name: TvRouteNames.home,
        builder: (context, state) => BlocProvider(
          create: (_) => locator<TvListCubit>(),
          child: AppRouteTrackingScope(
            routeName: state.name ?? TvRouteNames.home,
            screenName: 'tv_home',
            feature: 'tv',
            contentType: 'tv',
            child: const TvPage(),
          ),
        ),
      ),
    ],
  );
}

List<RouteBase> buildTvRoutes({
  required Widget invalidIdPage,
  GlobalKey<NavigatorState>? parentNavigatorKey,
}) {
  return [
    GoRoute(
      parentNavigatorKey: parentNavigatorKey,
      path: AppRoutePaths.tvPopular,
      name: TvRouteNames.popular,
      builder: (context, state) => BlocProvider(
        create: (_) => locator<TvListCubit>(),
        child: AppRouteTrackingScope(
          routeName: state.name ?? TvRouteNames.popular,
          screenName: 'tv_popular',
          feature: 'tv',
          contentType: 'tv',
          child: const PopularTvPage(),
        ),
      ),
    ),
    GoRoute(
      parentNavigatorKey: parentNavigatorKey,
      path: AppRoutePaths.tvTopRated,
      name: TvRouteNames.topRated,
      builder: (context, state) => BlocProvider(
        create: (_) => locator<TvListCubit>(),
        child: AppRouteTrackingScope(
          routeName: state.name ?? TvRouteNames.topRated,
          screenName: 'tv_top_rated',
          feature: 'tv',
          contentType: 'tv',
          child: const TopRatedTvPage(),
        ),
      ),
    ),
    GoRoute(
      parentNavigatorKey: parentNavigatorKey,
      path: AppRoutePaths.tvSearch,
      name: TvRouteNames.search,
      builder: (context, state) => BlocProvider(
        create: (_) => locator<TvSearchCubit>(),
        child: AppRouteTrackingScope(
          routeName: state.name ?? TvRouteNames.search,
          screenName: 'tv_search',
          feature: 'tv',
          contentType: 'tv',
          child: const SearchTvPage(),
        ),
      ),
    ),
    GoRoute(
      parentNavigatorKey: parentNavigatorKey,
      path: AppRoutePaths.tvDetailPattern,
      name: TvRouteNames.detail,
      builder: (context, state) {
        final id = int.tryParse(
          state.pathParameters[AppRouteParams.id] ?? '',
        );
        if (id == null) {
          return invalidIdPage;
        }
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => locator<TvDetailCubit>()),
            BlocProvider(create: (_) => locator<WatchlistTvCubit>()),
          ],
          child: AppRouteTrackingScope(
            routeName: state.name ?? TvRouteNames.detail,
            screenName: 'tv_detail',
            feature: 'tv',
            contentType: 'tv',
            contentId: id,
            child: TvDetailPage(id: id),
          ),
        );
      },
    ),
  ];
}
