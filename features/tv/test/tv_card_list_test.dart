import 'package:tv_domain/tv_domain.dart';
import 'package:tv/tv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  final tv = const Tv.watchlist(
    id: 1,
    name: 'Breaking Bad',
    posterPath: '/poster.jpg',
    overview: 'overview',
  );

  testWidgets('tv card tampil nama dan overview', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: TvCard(tv)),
      ),
    );

    expect(find.text('Breaking Bad'), findsOneWidget);
    expect(find.text('overview'), findsOneWidget);
  });

  testWidgets('tv card bisa dipencet', (tester) async {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => Scaffold(body: TvCard(tv)),
        ),
        GoRoute(
          name: 'tv-detail',
          path: '/detail',
          builder: (context, state) => const Scaffold(
            body: Text('halaman detail tv'),
          ),
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: router,
      ),
    );

    await tester.tap(find.byType(InkWell));
    await tester.pumpAndSettle();

    expect(find.text('halaman detail tv'), findsOneWidget);
  });
}
