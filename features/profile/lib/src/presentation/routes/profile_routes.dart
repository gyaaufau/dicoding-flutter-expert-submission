import 'package:core/core.dart';
import 'package:go_router/go_router.dart';

import '../pages/about_page.dart';
import '../pages/profile_page.dart';

class ProfileRouteNames {
  const ProfileRouteNames._();

  static const home = 'profile';
  static const about = 'about';
}

StatefulShellBranch buildProfileBranch() {
  return StatefulShellBranch(
    routes: [
      GoRoute(
        path: ProfilePage.routeName,
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

List<RouteBase> buildProfileRoutes() {
  return [
    GoRoute(
      path: AboutPage.routeName,
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
