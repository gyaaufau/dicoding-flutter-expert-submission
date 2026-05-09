import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:movie/movie.dart';
import 'package:movie_domain/movie_domain.dart';

void main() {
  final movie = const Movie.watchlist(
    id: 1,
    title: 'Spider-Man',
    posterPath: '/poster.jpg',
    overview: 'overview',
  );

  testWidgets('movie card should display title and overview', (tester) async {
    // arrange
    final widget = MaterialApp(
      home: Scaffold(body: MovieCard(movie)),
    );

    // act
    await tester.pumpWidget(widget);

    // assert
    expect(find.text('Spider-Man'), findsOneWidget);
    expect(find.text('overview'), findsOneWidget);
  });

  testWidgets('movie card should be clickable', (tester) async {
    // arrange
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => Scaffold(body: MovieCard(movie)),
        ),
        GoRoute(
          name: MovieRouteNames.detail,
          path: AppRoutePaths.moviesDetailPattern,
          builder: (context, state) =>
              const Scaffold(body: Text('halaman detail movie')),
        ),
      ],
    );

    // act
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.tap(find.byType(InkWell));
    await tester.pumpAndSettle();

    // assert
    expect(find.text('halaman detail movie'), findsOneWidget);
  });
}
