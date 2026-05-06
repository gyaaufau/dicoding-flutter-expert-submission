import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/tv.dart';
import 'package:tv_domain/tv_domain.dart';

class FakeTvRepository extends Fake implements TvRepository {}

class TestTvListCubit extends TvListCubit {
  TestTvListCubit(TvListState initialState)
    : super(
        getOnTheAirTvUseCase: GetOnTheAirTv(FakeTvRepository()),
        getPopularTvUseCase: GetPopularTv(FakeTvRepository()),
        getTopRatedTvUseCase: GetTopRatedTv(FakeTvRepository()),
      ) {
    emit(initialState);
  }

  @override
  Future<void> fetchOnTheAirTvShows() async {}

  @override
  Future<void> fetchPopularTvShows() async {}

  @override
  Future<void> fetchTopRatedTvShows() async {}
}

const testTv = Tv.watchlist(
  id: 1,
  name: 'Breaking Bad',
  posterPath: '/poster.jpg',
  overview: 'overview',
);

void main() {
  Widget makeTestableWidget(TvListCubit cubit) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context, child) => BlocProvider<TvListCubit>.value(
        value: cubit,
        child: const MaterialApp(home: TvPage()),
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading', (
    tester,
  ) async {
    // arrange
    final cubit = TestTvListCubit(
      const TvListState(
        onTheAirTvShowsState: RequestState.Loading,
        popularTvShowsState: RequestState.Loading,
        topRatedTvShowsState: RequestState.Loading,
      ),
    );

    // act
    await tester.pumpWidget(makeTestableWidget(cubit));

    // assert
    expect(find.byType(CircularProgressIndicator), findsNWidgets(3));
  });

  testWidgets('Page should display tv sections when data is loaded', (
    tester,
  ) async {
    // arrange
    final cubit = TestTvListCubit(
      const TvListState(
        onTheAirTvShowsState: RequestState.Loaded,
        popularTvShowsState: RequestState.Loaded,
        topRatedTvShowsState: RequestState.Loaded,
      ),
    );

    // act
    await tester.pumpWidget(makeTestableWidget(cubit));

    // assert
    expect(find.text('On The Air'), findsOneWidget);
    expect(find.text('Popular'), findsOneWidget);
    expect(find.text('Top Rated'), findsOneWidget);
    expect(find.text('See More'), findsNWidgets(2));
  });
}
