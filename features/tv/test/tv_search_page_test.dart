import 'package:dartz/dartz.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tv/tv.dart';
import 'package:tv_domain/tv_domain.dart';

class FakeTvRepository implements TvRepository {
  Future<Either<Failure, List<Tv>>> Function(String query)? onSearchTv;

  @override
  Future<Either<Failure, List<Tv>>> searchTv(String query) => onSearchTv!(query);

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class TestTvSearchCubit extends TvSearchCubit {
  TestTvSearchCubit(TvSearchState initialState)
    : super(searchTv: SearchTv(FakeTvRepository())) {
    emit(initialState);
  }

  String? submittedQuery;

  @override
  Future<void> fetchTvSearch(String query) async {
    submittedQuery = query;
  }
}

const testTv = Tv.watchlist(
  id: 1,
  name: 'Breaking Bad',
  posterPath: '/poster.jpg',
  overview: 'overview',
);

void main() {
  Widget makeTestableWidget(TestTvSearchCubit cubit) {
    return BlocProvider<TvSearchCubit>.value(
      value: cubit,
      child: const MaterialApp(home: SearchTvPage()),
    );
  }

  testWidgets('Page should display center progress bar when loading', (
    tester,
  ) async {
    // arrange
    final cubit = TestTvSearchCubit(
      const TvSearchState(state: RequestState.Loading),
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
    final cubit = TestTvSearchCubit(
      const TvSearchState(
        state: RequestState.Loaded,
        searchResult: <Tv>[testTv],
      ),
    );

    // act
    await tester.pumpWidget(makeTestableWidget(cubit));

    // assert
    expect(find.byType(ListView), findsOneWidget);
    expect(find.text('Breaking Bad'), findsOneWidget);
  });

  testWidgets('Page should submit query when text is entered', (tester) async {
    // arrange
    final cubit = TestTvSearchCubit(const TvSearchState());

    // act
    await tester.pumpWidget(makeTestableWidget(cubit));
    await tester.enterText(find.byType(TextField), 'breaking bad');
    await tester.testTextInput.receiveAction(TextInputAction.search);

    // assert
    expect(cubit.submittedQuery, 'breaking bad');
  });
}
