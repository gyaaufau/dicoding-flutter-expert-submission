import 'package:common/common.dart';
import 'package:movie_domain/movie_domain.dart';
import 'package:movie_domain/movie_domain.dart';
import 'package:movie_domain/movie_domain.dart';
import 'package:movie/movie.dart';
import 'package:movie/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class FakeMovieRepository extends Fake implements MovieRepository {}

class TestTopRatedMoviesCubit extends TopRatedMoviesCubit {
  TestTopRatedMoviesCubit(TopRatedMoviesState initialState)
      : super(getTopRatedMovies: GetTopRatedMovies(FakeMovieRepository())) {
    emit(initialState);
  }

  @override
  Future<void> fetchTopRatedMovies() async {}
}

void main() {
  Widget makeTestableWidget(TopRatedMoviesCubit cubit, Widget body) {
    return BlocProvider<TopRatedMoviesCubit>.value(
      value: cubit,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    final cubit = TestTopRatedMoviesCubit(
      const TopRatedMoviesState(state: RequestState.Loading),
    );

    await tester.pumpWidget(makeTestableWidget(cubit, TopRatedMoviesPage()));

    expect(find.byType(Center), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    final cubit = TestTopRatedMoviesCubit(
      const TopRatedMoviesState(
        state: RequestState.Loaded,
        movies: <Movie>[],
      ),
    );

    await tester.pumpWidget(makeTestableWidget(cubit, TopRatedMoviesPage()));

    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    final cubit = TestTopRatedMoviesCubit(
      const TopRatedMoviesState(
        state: RequestState.Error,
        message: 'Error message',
      ),
    );

    await tester.pumpWidget(makeTestableWidget(cubit, TopRatedMoviesPage()));

    expect(find.byKey(const Key('error_message')), findsOneWidget);
  });
}
