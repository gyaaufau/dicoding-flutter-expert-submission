import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:profile/profile.dart';

void main() {
  testWidgets('profile routes should build pages', (tester) async {
    // arrange
    final branch = buildProfileBranch();
    final routes = buildProfileRoutes();

    final router = GoRouter(
      initialLocation: AppRoutePaths.profile,
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, shell) => shell,
          branches: [branch],
        ),
        ...routes,
      ],
    );

    // act
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));

    // assert
    expect(find.byType(ProfilePage), findsOneWidget);
  });
}
