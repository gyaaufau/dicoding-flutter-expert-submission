import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:movie/movie.dart';
import 'package:movie_domain/movie_domain.dart';
import 'package:common/common.dart';

class FakeMovieRepository implements MovieRepository {
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class TestMovieDetailCubit extends MovieDetailCubit {
  TestMovieDetailCubit()
    : super(
        getMovieDetail: GetMovieDetail(FakeMovieRepository()),
        getMovieRecommendations: GetMovieRecommendations(FakeMovieRepository()),
        getWatchListStatus: GetWatchListStatus(FakeMovieRepository()),
        saveWatchlist: SaveWatchlist(FakeMovieRepository()),
        removeWatchlist: RemoveWatchlist(FakeMovieRepository()),
      );

  @override
  Future<void> fetchMovieDetail(int id) async {}

  @override
  Future<void> loadWatchlistStatus(int id) async {}
}

void main() {
  tearDown(() async {
    await GetIt.instance.reset();
  });

  test('movie routes should be created', () {
    // arrange
    final branch = buildMovieBranch();
    final routes = buildMovieRoutes(
      invalidIdPage: const Scaffold(body: Text('invalid movie id')),
    );

    // assert
    expect(branch.routes.length, 1);
    expect(routes.length, 4);
  });

  testWidgets('movie detail route should parse valid id', (tester) async {
    GetIt.instance.registerFactory<MovieDetailCubit>(() => TestMovieDetailCubit());
    GetIt.instance.registerFactory<WatchlistMovieCubit>(
      () => WatchlistMovieCubit(
        getWatchlistMovies: GetWatchlistMovies(FakeMovieRepository()),
      ),
    );

    final router = GoRouter(
      initialLocation: '/movies/123',
      routes: buildMovieRoutes(
        invalidIdPage: const Scaffold(body: Text('invalid movie id')),
      ),
    );

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(360, 690),
        builder: (context, child) => MaterialApp.router(routerConfig: router),
      ),
    );

    expect(find.byType(MovieDetailPage), findsOneWidget);
  });

  testWidgets('movie detail route should reject invalid id', (tester) async {
    final router = GoRouter(
      initialLocation: '/movies/abc',
      routes: buildMovieRoutes(
        invalidIdPage: const Scaffold(body: Text('invalid movie id')),
      ),
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));

    expect(find.text('invalid movie id'), findsOneWidget);
  });

  test('movie route constants should expose target paths', () {
    expect(AppRoutePaths.movies, '/movies');
    expect(AppRoutePaths.moviesDetailPattern, '/movies/:id');
    expect(AppRouteNames.moviesDetail, 'movies-detail');
    expect(AppRouteHelpers.movieDetail(123), '/movies/123');
  });

  test('movie injection should register cubits', () {
    // arrange
    final locator = GetIt.instance;
    locator.registerFactory<GetNowPlayingMovies>(() => throw UnimplementedError());
    locator.registerFactory<GetPopularMovies>(() => throw UnimplementedError());
    locator.registerFactory<GetTopRatedMovies>(() => throw UnimplementedError());
    locator.registerFactory<GetMovieDetail>(() => throw UnimplementedError());
    locator.registerFactory<GetMovieRecommendations>(() => throw UnimplementedError());
    locator.registerFactory<GetWatchListStatus>(() => throw UnimplementedError());
    locator.registerFactory<SaveWatchlist>(() => throw UnimplementedError());
    locator.registerFactory<RemoveWatchlist>(() => throw UnimplementedError());
    locator.registerFactory<SearchMovies>(() => throw UnimplementedError());
    locator.registerFactory<GetWatchlistMovies>(() => throw UnimplementedError());

    // act
    registerMovieFeatureDependencies(locator);

    // assert
    expect(locator.isRegistered<MovieListCubit>(), true);
    expect(locator.isRegistered<MovieDetailCubit>(), true);
    expect(locator.isRegistered<MovieSearchCubit>(), true);
    expect(locator.isRegistered<WatchlistMovieCubit>(), true);
  });
}
