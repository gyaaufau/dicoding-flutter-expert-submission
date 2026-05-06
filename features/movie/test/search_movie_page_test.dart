import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie/movie.dart';
import 'package:movie_domain/movie_domain.dart';
import 'package:mockito/mockito.dart';

import 'dummy_data/dummy_objects.dart';

class FakeMovieRepository extends Fake implements MovieRepository {}

class TestMovieSearchCubit extends MovieSearchCubit {
  TestMovieSearchCubit(MovieSearchState initialState)
    : super(searchMovies: SearchMovies(FakeMovieRepository())) {
    emit(initialState);
  }

  String? submittedQuery;

  @override
  Future<void> fetchMovieSearch(String query) async {
    submittedQuery = query;
  }
}

void main() {
  Widget makeTestableWidget(TestMovieSearchCubit cubit) {
    return BlocProvider<MovieSearchCubit>.value(
      value: cubit,
      child: const MaterialApp(home: SearchMoviePage()),
    );
  }

  testWidgets('Page should display center progress bar when loading', (
    tester,
  ) async {
    // arrange
    final cubit = TestMovieSearchCubit(
      const MovieSearchState(state: RequestState.Loading),
    );

    // act
    await tester.pumpWidget(makeTestableWidget(cubit));

    // assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded', (
    tester,
  ) async {
    // arrange
    final cubit = TestMovieSearchCubit(
      MovieSearchState(
        state: RequestState.Loaded,
        searchResult: <Movie>[testMovie],
      ),
    );

    // act
    await tester.pumpWidget(makeTestableWidget(cubit));

    // assert
    expect(find.byType(ListView), findsOneWidget);
    expect(find.text('Spider-Man'), findsOneWidget);
  });

  testWidgets('Page should submit query when text is entered', (tester) async {
    // arrange
    final cubit = TestMovieSearchCubit(const MovieSearchState());

    // act
    await tester.pumpWidget(makeTestableWidget(cubit));
    await tester.enterText(find.byType(TextField), 'spiderman');
    await tester.testTextInput.receiveAction(TextInputAction.search);

    // assert
    expect(cubit.submittedQuery, 'spiderman');
  });
}
