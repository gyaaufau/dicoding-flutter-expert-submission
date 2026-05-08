import 'package:common/common.dart';
import 'package:core/core.dart';
import 'package:ditonton/app.dart';
import 'package:ditonton/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie/movie.dart';
import 'package:movie_domain/movie_domain.dart';
import 'package:profile/profile.dart';
import 'package:tv/tv.dart';
import 'package:tv_domain/tv_domain.dart';
import 'package:watchlist/watchlist.dart';

class _FakeMovieRepository implements MovieRepository {
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeTvRepository implements TvRepository {
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _TestMovieListCubit extends MovieListCubit {
  _TestMovieListCubit()
    : super(
        getNowPlayingMovies: GetNowPlayingMovies(_FakeMovieRepository()),
        getPopularMovies: GetPopularMovies(_FakeMovieRepository()),
        getTopRatedMovies: GetTopRatedMovies(_FakeMovieRepository()),
      );

  @override
  Future<void> fetchNowPlayingMovies() async {}

  @override
  Future<void> fetchPopularMovies() async {}

  @override
  Future<void> fetchTopRatedMovies() async {}
}

class _TestMovieDetailCubit extends MovieDetailCubit {
  _TestMovieDetailCubit()
    : super(
        getMovieDetail: GetMovieDetail(_FakeMovieRepository()),
        getMovieRecommendations: GetMovieRecommendations(
          _FakeMovieRepository(),
        ),
        getWatchListStatus: GetWatchListStatus(_FakeMovieRepository()),
        saveWatchlist: SaveWatchlist(_FakeMovieRepository()),
        removeWatchlist: RemoveWatchlist(_FakeMovieRepository()),
      );

  @override
  Future<void> fetchMovieDetail(int id) async {}

  @override
  Future<void> loadWatchlistStatus(int id) async {}
}

class _TestMovieSearchCubit extends MovieSearchCubit {
  _TestMovieSearchCubit()
    : super(searchMovies: SearchMovies(_FakeMovieRepository()));

  @override
  Future<void> fetchMovieSearch(String query) async {}
}

class _TestPopularMoviesCubit extends PopularMoviesCubit {
  _TestPopularMoviesCubit()
    : super(GetPopularMovies(_FakeMovieRepository()));

  @override
  Future<void> fetchPopularMovies() async {}
}

class _TestTopRatedMoviesCubit extends TopRatedMoviesCubit {
  _TestTopRatedMoviesCubit()
    : super(getTopRatedMovies: GetTopRatedMovies(_FakeMovieRepository()));

  @override
  Future<void> fetchTopRatedMovies() async {}
}

class _TestWatchlistMovieCubit extends WatchlistMovieCubit {
  _TestWatchlistMovieCubit()
    : super(getWatchlistMovies: GetWatchlistMovies(_FakeMovieRepository()));

  @override
  Future<void> fetchWatchlistMovies() async {}
}

class _TestTvListCubit extends TvListCubit {
  _TestTvListCubit()
    : super(
        getOnTheAirTvUseCase: GetOnTheAirTv(_FakeTvRepository()),
        getPopularTvUseCase: GetPopularTv(_FakeTvRepository()),
        getTopRatedTvUseCase: GetTopRatedTv(_FakeTvRepository()),
      );

  @override
  Future<void> fetchOnTheAirTvShows() async {}

  @override
  Future<void> fetchPopularTvShows() async {}

  @override
  Future<void> fetchTopRatedTvShows() async {}
}

class _TestTvDetailCubit extends TvDetailCubit {
  _TestTvDetailCubit()
    : super(
        getTvDetail: GetTvDetail(_FakeTvRepository()),
        getTvRecommendations: GetTvRecommendations(_FakeTvRepository()),
        getTvSeasonDetail: GetTvSeasonDetail(_FakeTvRepository()),
      );

  @override
  Future<void> fetchTvDetail(int id) async {}

  @override
  Future<void> fetchTvSeasonDetail(int tvId, int seasonNumber) async {}
}

class _TestTvSearchCubit extends TvSearchCubit {
  _TestTvSearchCubit() : super(searchTv: SearchTv(_FakeTvRepository()));

  @override
  Future<void> fetchTvSearch(String query) async {}
}

class _TestWatchlistTvCubit extends WatchlistTvCubit {
  _TestWatchlistTvCubit()
    : super(
        getWatchlistTv: GetWatchlistTv(_FakeTvRepository()),
        getWatchlistTvStatus: GetWatchlistTvStatus(_FakeTvRepository()),
        saveWatchlistTv: SaveWatchlistTv(_FakeTvRepository()),
        removeWatchlistTv: RemoveWatchlistTv(_FakeTvRepository()),
      );

  @override
  Future<void> fetchWatchlistTv() async {}

  @override
  Future<void> loadWatchlistStatus(int id) async {}
}

void _registerRouteCubitFactories() {
  locator.registerFactory<MovieListCubit>(() => _TestMovieListCubit());
  locator.registerFactory<MovieDetailCubit>(() => _TestMovieDetailCubit());
  locator.registerFactory<MovieSearchCubit>(() => _TestMovieSearchCubit());
  locator.registerFactory<PopularMoviesCubit>(() => _TestPopularMoviesCubit());
  locator.registerFactory<TopRatedMoviesCubit>(() => _TestTopRatedMoviesCubit());
  locator.registerFactory<WatchlistMovieCubit>(() => _TestWatchlistMovieCubit());
  locator.registerFactory<TvListCubit>(() => _TestTvListCubit());
  locator.registerFactory<TvDetailCubit>(() => _TestTvDetailCubit());
  locator.registerFactory<TvSearchCubit>(() => _TestTvSearchCubit());
  locator.registerFactory<WatchlistTvCubit>(() => _TestWatchlistTvCubit());
}

Finder _bottomNavFinder() => find.byType(BottomNavigationBar);

Finder _visibleBottomNavFinder() => _bottomNavFinder().hitTestable();

Finder _visibleNotFoundTextFinder() =>
    find.text('Page not found :(').hitTestable();

Future<void> _goTo(WidgetTester tester, String path) async {
  appRouter.go(path);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
}

void main() {
  setUp(() async {
    await locator.reset();
    _registerRouteCubitFactories();
    appRouter.go(AppRoutePaths.movies);
  });

  tearDown(() async {
    await locator.reset();
  });

  testWidgets('MyApp should build initial movies route without provider error', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(HomeMoviePage), findsOneWidget);
    expect(_visibleBottomNavFinder(), findsOneWidget);
  });

  testWidgets('root router should keep bottom nav on shell routes', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(_visibleBottomNavFinder(), findsOneWidget);

    await _goTo(tester, AppRoutePaths.root);
    expect(find.byType(HomeMoviePage), findsOneWidget);
    expect(_visibleBottomNavFinder(), findsOneWidget);

    await _goTo(tester, AppRoutePaths.watchlist);
    expect(find.byType(WatchlistMoviesPage), findsOneWidget);
    expect(_visibleBottomNavFinder(), findsOneWidget);

    await _goTo(tester, AppRoutePaths.profile);
    expect(find.byType(ProfilePage), findsOneWidget);
    expect(_bottomNavFinder(), findsOneWidget);
  });

  testWidgets('root router should hide bottom nav on movie child routes', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    for (final path in [
      AppRoutePaths.moviesSearch,
      AppRoutePaths.moviesPopular,
      AppRoutePaths.moviesTopRated,
      AppRouteHelpers.movieDetail(123),
    ]) {
      await _goTo(tester, path);
      expect(_visibleBottomNavFinder(), findsNothing);
    }
  });

  testWidgets('search routes should resolve to search pages, not detail fallback', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    await _goTo(tester, AppRoutePaths.moviesSearch);
    expect(find.byType(SearchMoviePage), findsOneWidget);
    expect(_visibleNotFoundTextFinder(), findsNothing);

    await _goTo(tester, AppRoutePaths.tvSearch);
    expect(find.byType(SearchTvPage), findsOneWidget);
    expect(_visibleNotFoundTextFinder(), findsNothing);
  });

  testWidgets('root router should hide bottom nav on tv and profile child routes', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    for (final path in [
      AppRoutePaths.tvSearch,
      AppRoutePaths.tvPopular,
      AppRoutePaths.tvTopRated,
      AppRouteHelpers.tvDetail(456),
      AppRoutePaths.profileAbout,
    ]) {
      await _goTo(tester, path);
      expect(_visibleBottomNavFinder(), findsNothing);
    }
  });

  testWidgets('invalid detail routes should show not found page', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    await _goTo(tester, '${AppRoutePaths.movies}/abc');
    expect(_visibleNotFoundTextFinder(), findsOneWidget);

    await _goTo(tester, '${AppRoutePaths.tv}/abc');
    expect(_visibleNotFoundTextFinder(), findsOneWidget);
  });
}
