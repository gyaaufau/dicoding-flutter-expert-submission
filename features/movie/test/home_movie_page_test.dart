import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie/movie.dart';
import 'package:movie_domain/movie_domain.dart';
import 'package:mockito/mockito.dart';

import 'dummy_data/dummy_objects.dart';

class FakeMovieRepository extends Fake implements MovieRepository {}

class TestMovieListCubit extends MovieListCubit {
  TestMovieListCubit(MovieListState initialState)
    : super(
        getNowPlayingMovies: GetNowPlayingMovies(FakeMovieRepository()),
        getPopularMovies: GetPopularMovies(FakeMovieRepository()),
        getTopRatedMovies: GetTopRatedMovies(FakeMovieRepository()),
      ) {
    emit(initialState);
  }

  @override
  Future<void> fetchNowPlayingMovies() async {}

  @override
  Future<void> fetchPopularMovies() async {}

  @override
  Future<void> fetchTopRatedMovies() async {}
}

void main() {
  Widget makeTestableWidget(MovieListCubit cubit) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context, child) => BlocProvider<MovieListCubit>.value(
        value: cubit,
        child: const MaterialApp(home: HomeMoviePage()),
      ),
    );
  }

  testWidgets(
    'Page should display center progress bar when loading sections',
    (tester) async {
      // arrange
      final cubit = TestMovieListCubit(
        const MovieListState(
          nowPlayingState: RequestState.Loading,
          popularMoviesState: RequestState.Loading,
          topRatedMoviesState: RequestState.Loading,
        ),
      );

      // act
      await tester.pumpWidget(makeTestableWidget(cubit));

      // assert
      expect(find.text('Movies'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNWidgets(3));
    },
  );

  testWidgets('Page should display movie sections when data is loaded', (
    tester,
  ) async {
    // arrange
    final cubit = TestMovieListCubit(
      const MovieListState(
        nowPlayingState: RequestState.Loaded,
        popularMoviesState: RequestState.Loaded,
        topRatedMoviesState: RequestState.Loaded,
      ),
    );

    // act
    await tester.pumpWidget(makeTestableWidget(cubit));

    // assert
    expect(find.text('Now Playing'), findsOneWidget);
    expect(find.text('Popular'), findsOneWidget);
    expect(find.text('Top Rated'), findsOneWidget);
    expect(find.text('See More'), findsNWidgets(2));
  });
}
