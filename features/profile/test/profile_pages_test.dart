import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:profile/profile.dart';

void main() {
  testWidgets('Profile page should display basic profile content', (
    tester,
  ) async {
    // arrange
    const widget = MaterialApp(home: ProfilePage());

    // act
    await tester.pumpWidget(widget);

    // assert
    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('Argya Aulia Fauzandika'), findsOneWidget);
    expect(find.text('About App'), findsOneWidget);
  });

  testWidgets('About page should display app information', (tester) async {
    // arrange
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const ProfilePage(),
        ),
        ...buildProfileRoutes(),
      ],
    );

    // act
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.tap(find.text('About App'));
    await tester.pumpAndSettle();

    // assert
    expect(find.text('About'), findsOneWidget);
    expect(find.text('Ditonton'), findsOneWidget);
    expect(find.text('Developer'), findsOneWidget);
  });
}
