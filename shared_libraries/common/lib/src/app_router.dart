import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

GoRouter buildAppRouter({
  required String initialLocation,
  required RouteObserver<ModalRoute> observer,
  required Widget errorPage,
  GlobalKey<NavigatorState>? navigatorKey,
  required Widget Function(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  )
  shellBuilder,
  required List<StatefulShellBranch> branches,
  List<RouteBase> routes = const [],
}) {
  final rootNavigatorKey = navigatorKey ?? GlobalKey<NavigatorState>();

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: initialLocation,
    observers: [observer],
    routes: [
      GoRoute(path: '/', redirect: (context, state) => initialLocation),
      StatefulShellRoute.indexedStack(
        builder: shellBuilder,
        branches: branches,
      ),
      ...routes,
    ],
    errorBuilder: (context, state) => errorPage,
  );
}

class AppNotFoundPage extends StatelessWidget {
  const AppNotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Page not found :(')));
  }
}
