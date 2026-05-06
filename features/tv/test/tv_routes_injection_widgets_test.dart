import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tv/tv.dart';
import 'package:tv_domain/tv_domain.dart';

void main() {
  tearDown(() async {
    await GetIt.instance.reset();
  });

  test('tv routes should be created', () {
    // arrange
    final branch = buildTvBranch();
    final routes = buildTvRoutes(
      invalidIdPage: const Scaffold(body: Text('invalid tv id')),
    );

    // assert
    expect(branch.routes.length, 1);
    expect(routes.length, 4);
  });

  test('tv injection should register cubits', () {
    // arrange
    final locator = GetIt.instance;
    locator.registerFactory<GetOnTheAirTv>(() => throw UnimplementedError());
    locator.registerFactory<GetPopularTv>(() => throw UnimplementedError());
    locator.registerFactory<GetTopRatedTv>(() => throw UnimplementedError());
    locator.registerFactory<GetTvDetail>(() => throw UnimplementedError());
    locator.registerFactory<GetTvRecommendations>(() => throw UnimplementedError());
    locator.registerFactory<GetTvSeasonDetail>(() => throw UnimplementedError());
    locator.registerFactory<GetWatchlistTv>(() => throw UnimplementedError());
    locator.registerFactory<GetWatchlistTvStatus>(() => throw UnimplementedError());
    locator.registerFactory<SaveWatchlistTv>(() => throw UnimplementedError());
    locator.registerFactory<RemoveWatchlistTv>(() => throw UnimplementedError());
    locator.registerFactory<SearchTv>(() => throw UnimplementedError());

    // act
    registerTvFeatureDependencies(locator);

    // assert
    expect(locator.isRegistered<TvListCubit>(), true);
    expect(locator.isRegistered<TvDetailCubit>(), true);
    expect(locator.isRegistered<TvSearchCubit>(), true);
    expect(locator.isRegistered<WatchlistTvCubit>(), true);
  });

  testWidgets('tv helper widgets should render values and react tap', (
    tester,
  ) async {
    // arrange
    final season = TvSeason(
      airDate: '2020-01-01',
      episodeCount: 10,
      id: 1,
      name: 'Season 1',
      overview: 'overview',
      posterPath: '/poster.jpg',
      seasonNumber: 1,
      voteAverage: 8.5,
    );
    TvSeason? tappedSeason;

    // act
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(360, 690),
        builder: (context, child) => MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                const GenreChip(label: 'Drama'),
                const RatingChip(rating: 8.5),
                SeasonButtonPill(
                  season: season,
                  isActive: true,
                  onTap: (value) => tappedSeason = value,
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Season 1'));
    await tester.pump();

    // assert
    expect(find.text('Drama'), findsOneWidget);
    expect(find.text('8.5'), findsOneWidget);
    expect(tappedSeason, season);
  });
}
