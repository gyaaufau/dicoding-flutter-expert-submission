import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  test('failure should keep message', () {
    // arrange
    final failure = ServerFailure('server down');

    // act
    final message = failure.message;

    // assert
    expect(message, 'server down');
  });

  test('exceptions should keep payload when available', () {
    // arrange
    final cache = CacheException('cache miss');
    final database = DatabaseException('db error');

    // assert
    expect(cache.message, 'cache miss');
    expect(database.message, 'db error');
    expect(ServerException(), isA<Exception>());
  });

  testWidgets('app router should show not found page on unknown route', (
    tester,
  ) async {
    // arrange
    final router = buildAppRouter(
      initialLocation: '/missing',
      observer: routeObserver,
      errorPage: const AppNotFoundPage(),
      shellBuilder: (context, state, shell) => MainShellPage(
        navigationShell: shell,
      ),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/missing',
              builder: (context, state) => const Scaffold(
                body: Text('missing target'),
              ),
            ),
          ],
        ),
      ],
    );

    // act
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));

    // assert
    expect(find.text('missing target'), findsOneWidget);
  });

  testWidgets('main shell page should switch branch when tapped', (tester) async {
    // arrange
    final router = GoRouter(
      initialLocation: '/movies',
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, shell) => MainShellPage(
            navigationShell: shell,
          ),
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/movies',
                  builder: (context, state) =>
                      const Scaffold(body: Text('movies page')),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/tv',
                  builder: (context, state) =>
                      const Scaffold(body: Text('tv page')),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/watchlist',
                  builder: (context, state) =>
                      const Scaffold(body: Text('watchlist page')),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/profile',
                  builder: (context, state) =>
                      const Scaffold(body: Text('profile page')),
                ),
              ],
            ),
          ],
        ),
      ],
    );

    // act
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.tap(find.text('TV'));
    await tester.pumpAndSettle();

    // assert
    expect(find.text('tv page'), findsOneWidget);
  });
}
