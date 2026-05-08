import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:common/common.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tv/tv.dart';
import 'package:tv_domain/tv_domain.dart';

import 'dummy_data/dummy_objects.dart';
import 'json_reader.dart';

class FakeAnalyticsTracker implements AnalyticsTracker {
  final List<(String, Map<String, Object?>)> events = [];

  @override
  Future<void> logEvent(
    String name, {
    Map<String, Object?> params = const {},
  }) async {
    events.add((name, params));
  }

  @override
  Future<void> logScreenView({
    required String screenName,
    String? feature,
    Map<String, Object?> params = const {},
  }) async {}

  @override
  Future<void> setAnalyticsCollectionEnabled(bool enabled) async {}

  @override
  Future<void> setUserProperty({
    required String name,
    required String? value,
  }) async {}
}

class FakeTvRepository implements TvRepository {
  Future<Either<Failure, List<Tv>>> Function()? onGetOnTheAirTv;
  Future<Either<Failure, List<Tv>>> Function()? onGetPopularTv;
  Future<Either<Failure, List<Tv>>> Function()? onGetTopRatedTv;
  Future<Either<Failure, TvDetail>> Function(int id)? onGetTvDetail;
  Future<Either<Failure, List<Tv>>> Function(int id)? onGetTvRecommendations;
  Future<Either<Failure, TvSeasonDetail>> Function(int seriesId, int season)?
  onGetTvSeasonDetail;
  Future<Either<Failure, List<Tv>>> Function(String query)? onSearchTv;
  Future<Either<Failure, List<Tv>>> Function()? onGetWatchlistTv;
  Future<bool> Function(int id)? onIsAddedToWatchlist;
  Future<Either<Failure, String>> Function(TvDetail tv)? onSaveWatchlist;
  Future<Either<Failure, String>> Function(TvDetail tv)? onRemoveWatchlist;

  @override
  Future<Either<Failure, List<Tv>>> getOnTheAirTv() => onGetOnTheAirTv!();

  @override
  Future<Either<Failure, List<Tv>>> getPopularTv() => onGetPopularTv!();

  @override
  Future<Either<Failure, List<Tv>>> getTopRatedTv() => onGetTopRatedTv!();

  @override
  Future<Either<Failure, TvDetail>> getTvDetail(int id) => onGetTvDetail!(id);

  @override
  Future<Either<Failure, List<Tv>>> getTvRecommendations(int id) =>
      onGetTvRecommendations!(id);

  @override
  Future<Either<Failure, TvSeasonDetail>> getTvSeasonDetail(
    int seriesId,
    int seasonNumber,
  ) => onGetTvSeasonDetail!(seriesId, seasonNumber);

  @override
  Future<Either<Failure, List<Tv>>> searchTv(String query) =>
      onSearchTv!(query);

  @override
  Future<Either<Failure, List<Tv>>> getWatchlistTv() => onGetWatchlistTv!();

  @override
  Future<bool> isAddedToWatchlist(int id) => onIsAddedToWatchlist!(id);

  @override
  Future<Either<Failure, String>> saveWatchlist(TvDetail tv) =>
      onSaveWatchlist!(tv);

  @override
  Future<Either<Failure, String>> removeWatchlist(TvDetail tv) =>
      onRemoveWatchlist!(tv);
}

final testTvDetailEntity = TvDetailDto.fromJson(
  json.decode(readJson('dummy_data/tv_detail.json')),
).toEntity();

final testTvSeasonDetailEntity = TvSeasonDetailDto.fromJson(
  json.decode(readJson('dummy_data/tv_season_detail.json')),
).toEntity();

void main() {
  late FakeTvRepository repository;
  late FakeAnalyticsTracker analyticsTracker;

  setUp(() {
    repository = FakeTvRepository();
    analyticsTracker = FakeAnalyticsTracker();
    locator.registerSingleton<AnalyticsTracker>(analyticsTracker);
  });

  tearDown(() async {
    await locator.reset();
  });

  test(
    'should emit [Loading, Loaded] when on the air data is gotten',
    () async {
      // arrange
      repository.onGetOnTheAirTv = () async => Right(<Tv>[testWatchlistTv]);
      final cubit = TvListCubit(
        getOnTheAirTvUseCase: GetOnTheAirTv(repository),
        getPopularTvUseCase: GetPopularTv(repository),
        getTopRatedTvUseCase: GetTopRatedTv(repository),
      );

      // act
      final expectation = expectLater(
        cubit.stream,
        emitsInOrder([
          const TvListState(onTheAirTvShowsState: RequestState.Loading),
          TvListState(
            onTheAirTvShows: <Tv>[testWatchlistTv],
            onTheAirTvShowsState: RequestState.Loaded,
          ),
        ]),
      );
      await cubit.fetchOnTheAirTvShows();

      // assert
      await expectation;
    },
  );

  test('should emit [Loading, Error] when search is unsuccessful', () async {
    // arrange
    repository.onSearchTv = (_) async => Left(ServerFailure('Failed'));
    final cubit = TvSearchCubit(searchTv: SearchTv(repository));

    // act
    final expectation = expectLater(
      cubit.stream,
      emitsInOrder([
        const TvSearchState(state: RequestState.Loading),
        const TvSearchState(state: RequestState.Error, message: 'Failed'),
      ]),
    );
    await cubit.fetchTvSearch('bad');

    // assert
    await expectation;
    expect(analyticsTracker.events.single.$1, 'search_submitted');
    expect(analyticsTracker.events.single.$2['query_length'], 3);
  });

  test(
    'should emit detail and recommendation data when fetch detail is successful',
    () async {
      // arrange
      repository.onGetTvDetail = (_) async => Right(testTvDetailEntity);
      repository.onGetTvRecommendations = (_) async =>
          Right(<Tv>[testWatchlistTv]);
      final cubit = TvDetailCubit(
        getTvDetail: GetTvDetail(repository),
        getTvRecommendations: GetTvRecommendations(repository),
        getTvSeasonDetail: GetTvSeasonDetail(repository),
      );

      // act
      final expectation = expectLater(
        cubit.stream,
        emitsInOrder([
          const TvDetailState(tvState: RequestState.Loading),
          isA<TvDetailState>()
              .having((s) => s.tv, 'tv', testTvDetailEntity)
              .having(
                (s) => s.recommendationState,
                'recommendationState',
                RequestState.Loading,
              ),
          isA<TvDetailState>()
              .having((s) => s.tvState, 'tvState', RequestState.Loaded)
              .having((s) => s.tvRecommendations, 'tvRecommendations', <Tv>[
                testWatchlistTv,
              ]),
        ]),
      );
      await cubit.fetchTvDetail(1);

      // assert
      await expectation;
      expect(analyticsTracker.events.single.$1, 'tv_detail_viewed');
      expect(
        analyticsTracker.events.single.$2['content_id'],
        testTvDetailEntity.id,
      );
    },
  );

  test(
    'should emit season data when fetch season detail is successful',
    () async {
      // arrange
      repository.onGetTvSeasonDetail = (_, __) async =>
          Right(testTvSeasonDetailEntity);
      final cubit = TvDetailCubit(
        getTvDetail: GetTvDetail(repository),
        getTvRecommendations: GetTvRecommendations(repository),
        getTvSeasonDetail: GetTvSeasonDetail(repository),
      );

      // act
      final expectation = expectLater(
        cubit.stream,
        emitsInOrder([
          const TvDetailState(tvSeasonState: RequestState.Loading),
          isA<TvDetailState>()
              .having(
                (s) => s.tvSeasonState,
                'tvSeasonState',
                RequestState.Loaded,
              )
              .having(
                (s) => s.tvSeasonsDetails,
                'tvSeasonsDetails',
                testTvSeasonDetailEntity,
              ),
        ]),
      );
      await cubit.fetchTvSeasonDetail(1, 1);

      // assert
      await expectation;
      expect(analyticsTracker.events.single.$1, 'season_detail_viewed');
      expect(analyticsTracker.events.single.$2['season_number'], 1);
    },
  );

  test(
    'should log watchlist_added when save watchlist is successful',
    () async {
      // arrange
      repository.onSaveWatchlist = (_) async =>
          Right(WatchlistTvCubit.watchlistAddSuccessMessage);
      repository.onIsAddedToWatchlist = (_) async => true;
      final cubit = WatchlistTvCubit(
        getWatchlistTv: GetWatchlistTv(repository),
        getWatchlistTvStatus: GetWatchlistTvStatus(repository),
        saveWatchlistTv: SaveWatchlistTv(repository),
        removeWatchlistTv: RemoveWatchlistTv(repository),
      );

      // act
      await cubit.addWatchlist(testTvDetailEntity);

      // assert
      expect(analyticsTracker.events.single.$1, 'watchlist_added');
      expect(
        analyticsTracker.events.single.$2['content_id'],
        testTvDetailEntity.id,
      );
    },
  );
}
