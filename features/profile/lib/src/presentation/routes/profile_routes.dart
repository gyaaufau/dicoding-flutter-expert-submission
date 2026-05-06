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
        builder: (context, state) => const ProfilePage(),
      ),
    ],
  );
}

List<RouteBase> buildProfileRoutes() {
  return [
    GoRoute(
      path: AboutPage.routeName,
      name: ProfileRouteNames.about,
      builder: (context, state) => const AboutPage(),
    ),
  ];
}
