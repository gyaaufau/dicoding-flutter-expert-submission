import 'package:common/common.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../pages/about_page.dart';
import '../pages/profile_page.dart';

class ProfileRouteNames {
  const ProfileRouteNames._();

  static const home = AppRouteNames.profile;
  static const about = AppRouteNames.profileAbout;
}

StatefulShellBranch buildProfileBranch() {
  return StatefulShellBranch(
    routes: [
      GoRoute(
        path: AppRoutePaths.profile,
        name: ProfileRouteNames.home,
        builder: (context, state) => AppRouteTrackingScope(
          routeName: state.name ?? ProfileRouteNames.home,
          screenName: 'profile_home',
          feature: 'profile',
          contentType: 'profile',
          child: const ProfilePage(),
        ),
      ),
    ],
  );
}

List<RouteBase> buildProfileRoutes({
  GlobalKey<NavigatorState>? parentNavigatorKey,
}) {
  return [
    GoRoute(
      parentNavigatorKey: parentNavigatorKey,
      path: AppRoutePaths.profileAbout,
      name: ProfileRouteNames.about,
      builder: (context, state) => AppRouteTrackingScope(
        routeName: state.name ?? ProfileRouteNames.about,
        screenName: 'profile_about',
        feature: 'profile',
        contentType: 'profile',
        child: const AboutPage(),
      ),
    ),
  ];
}
