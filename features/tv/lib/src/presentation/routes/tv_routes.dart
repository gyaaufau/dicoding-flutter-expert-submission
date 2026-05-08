import 'package:core/core.dart';
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
        builder: (context, state) => AppRouteTrackingScope(
          routeName: state.name ?? TvRouteNames.home,
          screenName: 'tv_home',
          feature: 'tv',
          contentType: 'tv',
          child: const TvPage(),
        ),
      ),
    ],
  );
}

List<RouteBase> buildTvRoutes({required Widget invalidIdPage}) {
  return [
    GoRoute(
      path: PopularTvPage.ROUTE_NAME,
      name: TvRouteNames.popular,
      builder: (context, state) => AppRouteTrackingScope(
        routeName: state.name ?? TvRouteNames.popular,
        screenName: 'tv_popular',
        feature: 'tv',
        contentType: 'tv',
        child: const PopularTvPage(),
      ),
    ),
    GoRoute(
      path: TopRatedTvPage.ROUTE_NAME,
      name: TvRouteNames.topRated,
      builder: (context, state) => AppRouteTrackingScope(
        routeName: state.name ?? TvRouteNames.topRated,
        screenName: 'tv_top_rated',
        feature: 'tv',
        contentType: 'tv',
        child: const TopRatedTvPage(),
      ),
    ),
    GoRoute(
      path: TvDetailPage.routeName,
      name: TvRouteNames.detail,
      builder: (context, state) {
        final id = state.extra is int ? state.extra as int : null;
        if (id == null) {
          return invalidIdPage;
        }
        return AppRouteTrackingScope(
          routeName: state.name ?? TvRouteNames.detail,
          screenName: 'tv_detail',
          feature: 'tv',
          contentType: 'tv',
          contentId: id,
          child: TvDetailPage(id: id),
        );
      },
    ),
    GoRoute(
      path: SearchTvPage.ROUTE_NAME,
      name: TvRouteNames.search,
      builder: (context, state) => AppRouteTrackingScope(
        routeName: state.name ?? TvRouteNames.search,
        screenName: 'tv_search',
        feature: 'tv',
        contentType: 'tv',
        child: const SearchTvPage(),
      ),
    ),
  ];
}
