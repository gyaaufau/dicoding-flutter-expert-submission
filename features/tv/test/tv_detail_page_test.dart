import 'dart:convert';

import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tv/tv.dart';
import 'package:tv_domain/tv_domain.dart';

import 'dummy_data/dummy_objects.dart';
import 'json_reader.dart';

class FakeTvRepository implements TvRepository {
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final testTvDetailEntity = TvDetailDto.fromJson(
  json.decode(readJson('dummy_data/tv_detail.json')),
).toEntity();

final testTvSeasonDetailEntity = TvSeasonDetailDto.fromJson(
  json.decode(readJson('dummy_data/tv_season_detail.json')),
).toEntity();

class TestTvDetailCubit extends TvDetailCubit {
  TestTvDetailCubit(TvDetailState initialState)
    : super(
        getTvDetail: GetTvDetail(FakeTvRepository()),
        getTvRecommendations: GetTvRecommendations(FakeTvRepository()),
        getTvSeasonDetail: GetTvSeasonDetail(FakeTvRepository()),
      ) {
    emit(initialState);
  }

  @override
  Future<void> fetchTvDetail(int id) async {}

  @override
  Future<void> fetchTvSeasonDetail(int tvId, int seasonNumber) async {}
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
  Future<void> loadWatchlistStatus(int id) async {}

  @override
  Future<void> fetchWatchlistTv() async {}
}

void main() {
  Widget makeTestableWidget(
    TvDetailCubit detailCubit,
    WatchlistTvCubit watchlistCubit,
  ) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context, child) => MultiBlocProvider(
        providers: [
          BlocProvider<TvDetailCubit>.value(value: detailCubit),
          BlocProvider<WatchlistTvCubit>.value(value: watchlistCubit),
        ],
        child: const MaterialApp(home: TvDetailPage(id: 1)),
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading', (
    tester,
  ) async {
    // arrange
    final detailCubit = TestTvDetailCubit(
      const TvDetailState(tvState: RequestState.Loading),
    );
    final watchlistCubit = TestWatchlistTvCubit(const WatchlistTvState());

    // act
    await tester.pumpWidget(makeTestableWidget(detailCubit, watchlistCubit));

    // assert
    expect(find.byType(CustomScrollView), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNWidgets(2));
  });

  testWidgets('Page should display tv detail content when state loaded', (
    tester,
  ) async {
    // arrange
    final detailCubit = TestTvDetailCubit(
      TvDetailState(
        tv: testTvDetailEntity,
        tvState: RequestState.Loaded,
        recommendationState: RequestState.Loaded,
        tvRecommendations: <Tv>[testWatchlistTv],
        selectedSeason: testTvDetailEntity.seasons.first,
        tvSeasonState: RequestState.Loaded,
        tvSeasonsDetails: testTvSeasonDetailEntity,
      ),
    );
    final watchlistCubit = TestWatchlistTvCubit(
      const WatchlistTvState(isAddedToWatchlist: false),
    );

    // act
    await tester.pumpWidget(makeTestableWidget(detailCubit, watchlistCubit));

    // assert
    expect(find.text('Seasons'), findsOneWidget);
    expect(find.text('Overview'), findsOneWidget);
    expect(find.text('Recommendations'), findsOneWidget);
    expect(find.text('Add to Watchlist'), findsOneWidget);
  });

  testWidgets('Page should display text with message when Error', (
    tester,
  ) async {
    // arrange
    final detailCubit = TestTvDetailCubit(
      const TvDetailState(
        tvState: RequestState.Error,
        message: 'Gagal load detail tv',
      ),
    );
    final watchlistCubit = TestWatchlistTvCubit(const WatchlistTvState());

    // act
    await tester.pumpWidget(makeTestableWidget(detailCubit, watchlistCubit));

    // assert
    expect(find.text('TV detail error'), findsOneWidget);
    expect(find.text('Gagal load detail tv'), findsOneWidget);
  });
}
