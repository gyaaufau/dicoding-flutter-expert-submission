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

class TestPopularMoviesCubit extends PopularMoviesCubit {
  TestPopularMoviesCubit(PopularMoviesState initialState)
      : super(GetPopularMovies(FakeMovieRepository())) {
    emit(initialState);
  }

  @override
  Future<void> fetchPopularMovies() async {}
}

void main() {
  Widget makeTestableWidget(PopularMoviesCubit cubit, Widget body) {
    return BlocProvider<PopularMoviesCubit>.value(
      value: cubit,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    final cubit = TestPopularMoviesCubit(
      const PopularMoviesState(state: RequestState.Loading),
    );

    await tester.pumpWidget(makeTestableWidget(cubit, PopularMoviesPage()));

    expect(find.byType(Center), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    final cubit = TestPopularMoviesCubit(
      const PopularMoviesState(
        state: RequestState.Loaded,
        movies: <Movie>[],
      ),
    );

    await tester.pumpWidget(makeTestableWidget(cubit, PopularMoviesPage()));

    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    final cubit = TestPopularMoviesCubit(
      const PopularMoviesState(
        state: RequestState.Error,
        message: 'Error message',
      ),
    );

    await tester.pumpWidget(makeTestableWidget(cubit, PopularMoviesPage()));

    expect(find.byKey(const Key('error_message')), findsOneWidget);
  });
}
