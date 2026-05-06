import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../pages/popular_tv_page.dart';
import '../pages/search_tv_page.dart';
import '../pages/top_rated_tv_page.dart';
import '../pages/tv_detail_page.dart';
import '../pages/tv_page.dart';

class TvRouteNames {
  const TvRouteNames._();

  static const home = 'tv';
  static const popular = 'popular-tv';
  static const topRated = 'top-rated-tv';
  static const detail = 'tv-detail';
  static const search = 'search-tv';
}

StatefulShellBranch buildTvBranch() {
  return StatefulShellBranch(
    routes: [
      GoRoute(
        path: TvPage.ROUTE_NAME,
        name: TvRouteNames.home,
        builder: (context, state) => const TvPage(),
      ),
    ],
  );
}

List<RouteBase> buildTvRoutes({required Widget invalidIdPage}) {
  return [
    GoRoute(
      path: PopularTvPage.ROUTE_NAME,
      name: TvRouteNames.popular,
      builder: (context, state) => const PopularTvPage(),
    ),
    GoRoute(
      path: TopRatedTvPage.ROUTE_NAME,
      name: TvRouteNames.topRated,
      builder: (context, state) => const TopRatedTvPage(),
    ),
    GoRoute(
      path: TvDetailPage.routeName,
      name: TvRouteNames.detail,
      builder: (context, state) {
        final id = state.extra is int ? state.extra as int : null;
        if (id == null) {
          return invalidIdPage;
        }
        return TvDetailPage(id: id);
      },
    ),
    GoRoute(
      path: SearchTvPage.ROUTE_NAME,
      name: TvRouteNames.search,
      builder: (context, state) => const SearchTvPage(),
    ),
  ];
}
