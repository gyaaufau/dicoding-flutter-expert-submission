import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
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
  TestWatchlistMovieCubit(WatchlistMovieState initialState)
    : super(getWatchlistMovies: GetWatchlistMovies(FakeMovieRepository())) {
    emit(initialState);
  }

  @override
  Future<void> fetchWatchlistMovies() async {}
}

class TestWatchlistTvCubit extends WatchlistTvCubit {
  TestWatchlistTvCubit(WatchlistTvState initialState)
    : super(
        getWatchlistTv: GetWatchlistTv(FakeTvRepository()),
        getWatchlistTvStatus: GetWatchlistTvStatus(FakeTvRepository()),
        saveWatchlistTv: SaveWatchlistTv(FakeTvRepository()),
        removeWatchlistTv: RemoveWatchlistTv(FakeTvRepository()),
      ) {
    emit(initialState);
  }

  @override
  Future<void> fetchWatchlistTv() async {}

  @override
  Future<void> loadWatchlistStatus(int id) async {}
}

const testMovie = Movie.watchlist(
  id: 1,
  title: 'Spider-Man',
  posterPath: '/poster.jpg',
  overview: 'overview',
);

const testTv = Tv.watchlist(
  id: 1,
  name: 'Breaking Bad',
  posterPath: '/poster.jpg',
  overview: 'overview',
);

void main() {
  Widget makeTestableWidget(
    WatchlistMovieCubit movieCubit,
    WatchlistTvCubit tvCubit,
  ) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<WatchlistMovieCubit>.value(value: movieCubit),
        BlocProvider<WatchlistTvCubit>.value(value: tvCubit),
      ],
      child: const MaterialApp(home: WatchlistMoviesPage()),
    );
  }

  testWidgets('Page should display tabs and movie watchlist content', (
    tester,
  ) async {
    // arrange
    final movieCubit = TestWatchlistMovieCubit(
      const WatchlistMovieState(
        watchlistState: RequestState.Loaded,
        watchlistMovies: <Movie>[testMovie],
      ),
    );
    final tvCubit = TestWatchlistTvCubit(
      const WatchlistTvState(
        watchlistState: RequestState.Loaded,
        watchlistTv: <Tv>[testTv],
      ),
    );

    // act
    await tester.pumpWidget(makeTestableWidget(movieCubit, tvCubit));

    // assert
    expect(find.text('Watchlist'), findsOneWidget);
    expect(find.text('Movies'), findsOneWidget);
    expect(find.text('TV'), findsOneWidget);
    expect(find.text('Spider-Man'), findsOneWidget);
  });

  testWidgets('Page should display empty message when watchlist is empty', (
    tester,
  ) async {
    // arrange
    final movieCubit = TestWatchlistMovieCubit(
      const WatchlistMovieState(watchlistState: RequestState.Loaded),
    );
    final tvCubit = TestWatchlistTvCubit(
      const WatchlistTvState(watchlistState: RequestState.Loaded),
    );

    // act
    await tester.pumpWidget(makeTestableWidget(movieCubit, tvCubit));

    // assert
    expect(find.text('Watchlist movie masih kosong'), findsOneWidget);
  });
}
