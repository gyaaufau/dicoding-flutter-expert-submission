import 'package:dependencies/dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:movie/movie.dart';
import 'package:movie_domain/movie_domain.dart';

void main() {
  tearDown(() async {
    await GetIt.instance.reset();
  });

  test('movie routes should be created', () {
    // arrange
    final branch = buildMovieBranch();
    final routes = buildMovieRoutes(
      invalidIdPage: const Scaffold(body: Text('invalid movie id')),
    );

    // assert
    expect(branch.routes.length, 1);
    expect(routes.length, 4);
  });

  test('movie injection should register cubits', () {
    // arrange
    final locator = GetIt.instance;
    locator.registerFactory<GetNowPlayingMovies>(() => throw UnimplementedError());
    locator.registerFactory<GetPopularMovies>(() => throw UnimplementedError());
    locator.registerFactory<GetTopRatedMovies>(() => throw UnimplementedError());
    locator.registerFactory<GetMovieDetail>(() => throw UnimplementedError());
    locator.registerFactory<GetMovieRecommendations>(() => throw UnimplementedError());
    locator.registerFactory<GetWatchListStatus>(() => throw UnimplementedError());
    locator.registerFactory<SaveWatchlist>(() => throw UnimplementedError());
    locator.registerFactory<RemoveWatchlist>(() => throw UnimplementedError());
    locator.registerFactory<SearchMovies>(() => throw UnimplementedError());
    locator.registerFactory<GetWatchlistMovies>(() => throw UnimplementedError());

    // act
    registerMovieFeatureDependencies(locator);

    // assert
    expect(locator.isRegistered<MovieListCubit>(), true);
    expect(locator.isRegistered<MovieDetailCubit>(), true);
    expect(locator.isRegistered<MovieSearchCubit>(), true);
    expect(locator.isRegistered<WatchlistMovieCubit>(), true);
  });
}
