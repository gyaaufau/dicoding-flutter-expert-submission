import 'package:common/common.dart';
import 'package:movie_domain/movie_domain.dart';
import 'package:movie_domain/movie_domain.dart';
import 'package:movie_domain/movie_domain.dart';
import 'package:movie_domain/movie_domain.dart';
import 'package:movie_domain/movie_domain.dart';
import 'package:movie_domain/movie_domain.dart';
import 'package:movie/movie.dart';
import 'package:movie/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'dummy_data/dummy_objects.dart';

class FakeMovieRepository extends Fake implements MovieRepository {}

class TestMovieDetailCubit extends MovieDetailCubit {
  TestMovieDetailCubit(MovieDetailState initialState)
      : super(
          getMovieDetail: GetMovieDetail(FakeMovieRepository()),
          getMovieRecommendations:
              GetMovieRecommendations(FakeMovieRepository()),
          getWatchListStatus: GetWatchListStatus(FakeMovieRepository()),
          saveWatchlist: SaveWatchlist(FakeMovieRepository()),
          removeWatchlist: RemoveWatchlist(FakeMovieRepository()),
        ) {
    emit(initialState);
  }

  @override
  Future<void> fetchMovieDetail(int id) async {}

  @override
  Future<void> loadWatchlistStatus(int id) async {}
}

void main() {
  Widget makeTestableWidget(MovieDetailCubit cubit, Widget body) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context, child) => BlocProvider<MovieDetailCubit>.value(
        value: cubit,
        child: MaterialApp(home: body),
      ),
    );
  }

  testWidgets('show loading indicator when state loading', (
    WidgetTester tester,
  ) async {
    final cubit = TestMovieDetailCubit(
      const MovieDetailState(
        movieState: RequestState.Loading,
        recommendationState: RequestState.Empty,
      ),
    );

    await tester.pumpWidget(
      makeTestableWidget(cubit, const MovieDetailPage(id: 1)),
    );

    expect(find.byType(CustomScrollView), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNWidgets(2));
  });

  testWidgets('show movie detail content when state loaded', (
    WidgetTester tester,
  ) async {
    final cubit = TestMovieDetailCubit(
      MovieDetailState(
        movieState: RequestState.Loaded,
        movie: testMovieDetail,
        recommendationState: RequestState.Empty,
        movieRecommendations: testMovieList,
        isAddedToWatchlist: false,
      ),
    );

    await tester.pumpWidget(
      makeTestableWidget(cubit, const MovieDetailPage(id: 1)),
    );

    expect(find.byType(SliverAppBar), findsOneWidget);
    expect(find.text('Add to Watchlist'), findsOneWidget);
    expect(find.text('overview'), findsOneWidget);
  });

  testWidgets('show error placeholder when state error', (
    WidgetTester tester,
  ) async {
    final cubit = TestMovieDetailCubit(
      const MovieDetailState(
        movieState: RequestState.Error,
        message: 'Gagal load detail',
      ),
    );

    await tester.pumpWidget(
      makeTestableWidget(cubit, const MovieDetailPage(id: 1)),
    );

    expect(find.text('Movie detail error'), findsOneWidget);
    expect(find.text('Gagal load detail'), findsOneWidget);
  });
}
