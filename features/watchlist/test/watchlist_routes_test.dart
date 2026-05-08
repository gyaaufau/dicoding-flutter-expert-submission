import 'package:common/common.dart';
import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:movie/movie.dart';
import 'package:movie_domain/movie_domain.dart';
import 'package:tv/tv.dart';
import 'package:tv_domain/tv_domain.dart';
import 'package:watchlist/watchlist.dart';

class FakeMovieRepository implements MovieRepository {
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeTvRepository implements TvRepository {
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class TestWatchlistMovieCubit extends WatchlistMovieCubit {
  TestWatchlistMovieCubit()
    : super(getWatchlistMovies: GetWatchlistMovies(FakeMovieRepository()));

  @override
  Future<void> fetchWatchlistMovies() async {}
}

class TestWatchlistTvCubit extends WatchlistTvCubit {
  TestWatchlistTvCubit()
    : super(
        getWatchlistTv: GetWatchlistTv(FakeTvRepository()),
        getWatchlistTvStatus: GetWatchlistTvStatus(FakeTvRepository()),
        saveWatchlistTv: SaveWatchlistTv(FakeTvRepository()),
        removeWatchlistTv: RemoveWatchlistTv(FakeTvRepository()),
      );

  @override
  Future<void> fetchWatchlistTv() async {}

  @override
  Future<void> loadWatchlistStatus(int id) async {}
}

void main() {
  tearDown(() async {
    await GetIt.instance.reset();
  });

  testWidgets('watchlist route should build page', (tester) async {
    // arrange
    GetIt.instance.registerFactory<WatchlistMovieCubit>(
      () => TestWatchlistMovieCubit(),
    );
    GetIt.instance.registerFactory<WatchlistTvCubit>(
      () => TestWatchlistTvCubit(),
    );

    final branch = buildWatchlistBranch();
    final router = GoRouter(
      initialLocation: AppRoutePaths.watchlist,
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, shell) => shell,
          branches: [branch],
        ),
      ],
    );

    // act
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));

    // assert
    expect(find.byType(WatchlistMoviesPage), findsOneWidget);
  });
}
