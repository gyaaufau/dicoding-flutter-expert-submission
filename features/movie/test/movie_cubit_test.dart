import 'package:dartz/dartz.dart';
import 'package:common/common.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie/movie.dart';
import 'package:movie_domain/movie_domain.dart';

import 'dummy_data/dummy_objects.dart';

class FakeMovieRepository implements MovieRepository {
  Future<Either<Failure, List<Movie>>> Function()? onGetNowPlayingMovies;
  Future<Either<Failure, List<Movie>>> Function()? onGetPopularMovies;
  Future<Either<Failure, List<Movie>>> Function()? onGetTopRatedMovies;
  Future<Either<Failure, MovieDetail>> Function(int id)? onGetMovieDetail;
  Future<Either<Failure, List<Movie>>> Function(int id)?
  onGetMovieRecommendations;
  Future<Either<Failure, List<Movie>>> Function(String query)? onSearchMovies;
  Future<Either<Failure, String>> Function(MovieDetail movie)? onSaveWatchlist;
  Future<Either<Failure, String>> Function(MovieDetail movie)?
  onRemoveWatchlist;
  Future<bool> Function(int id)? onIsAddedToWatchlist;
  Future<Either<Failure, List<Movie>>> Function()? onGetWatchlistMovies;

  @override
  Future<Either<Failure, List<Movie>>> getNowPlayingMovies() =>
      onGetNowPlayingMovies!();

  @override
  Future<Either<Failure, List<Movie>>> getPopularMovies() =>
      onGetPopularMovies!();

  @override
  Future<Either<Failure, List<Movie>>> getTopRatedMovies() =>
      onGetTopRatedMovies!();

  @override
  Future<Either<Failure, MovieDetail>> getMovieDetail(int id) =>
      onGetMovieDetail!(id);

  @override
  Future<Either<Failure, List<Movie>>> getMovieRecommendations(int id) =>
      onGetMovieRecommendations!(id);

  @override
  Future<Either<Failure, List<Movie>>> searchMovies(String query) =>
      onSearchMovies!(query);

  @override
  Future<Either<Failure, String>> saveWatchlist(MovieDetail movie) =>
      onSaveWatchlist!(movie);

  @override
  Future<Either<Failure, String>> removeWatchlist(MovieDetail movie) =>
      onRemoveWatchlist!(movie);

  @override
  Future<bool> isAddedToWatchlist(int id) => onIsAddedToWatchlist!(id);

  @override
  Future<Either<Failure, List<Movie>>> getWatchlistMovies() =>
      onGetWatchlistMovies!();
}

void main() {
  late FakeMovieRepository repository;

  setUp(() {
    repository = FakeMovieRepository();
  });

  test('should emit [Loading, Loaded] when now playing data is gotten', () async {
    // arrange
    repository.onGetNowPlayingMovies = () async => Right(testMovieList);
    final cubit = MovieListCubit(
      getNowPlayingMovies: GetNowPlayingMovies(repository),
      getPopularMovies: GetPopularMovies(repository),
      getTopRatedMovies: GetTopRatedMovies(repository),
    );

    // act
    final expectation = expectLater(
      cubit.stream,
      emitsInOrder([
        const MovieListState(nowPlayingState: RequestState.Loading),
        MovieListState(
          nowPlayingMovies: <Movie>[testMovie],
          nowPlayingState: RequestState.Loaded,
        ),
      ]),
    );
    await cubit.fetchNowPlayingMovies();

    // assert
    await expectation;
  });

  test('should emit [Loading, Error] when search is unsuccessful', () async {
    // arrange
    repository.onSearchMovies =
        (_) async => Left(ServerFailure('Failed to search'));
    final cubit = MovieSearchCubit(searchMovies: SearchMovies(repository));

    // act
    final expectation = expectLater(
      cubit.stream,
      emitsInOrder([
        const MovieSearchState(state: RequestState.Loading),
        const MovieSearchState(
          state: RequestState.Error,
          message: 'Failed to search',
        ),
      ]),
    );
    await cubit.fetchMovieSearch('spiderman');

    // assert
    await expectation;
  });

  test('should emit [Loading, Loaded] when watchlist data is gotten', () async {
    // arrange
    repository.onGetWatchlistMovies = () async => Right(testMovieList);
    final cubit = WatchlistMovieCubit(
      getWatchlistMovies: GetWatchlistMovies(repository),
    );

    // act
    final expectation = expectLater(
      cubit.stream,
      emitsInOrder([
        const WatchlistMovieState(watchlistState: RequestState.Loading),
        WatchlistMovieState(
          watchlistMovies: <Movie>[testMovie],
          watchlistState: RequestState.Loaded,
        ),
      ]),
    );
    await cubit.fetchWatchlistMovies();

    // assert
    await expectation;
  });

  test(
    'should emit detail and recommendation data when fetch detail is successful',
    () async {
      // arrange
      repository.onGetMovieDetail = (_) async => Right(testMovieDetail);
      repository.onGetMovieRecommendations = (_) async => Right(testMovieList);
      final cubit = MovieDetailCubit(
        getMovieDetail: GetMovieDetail(repository),
        getMovieRecommendations: GetMovieRecommendations(repository),
        getWatchListStatus: GetWatchListStatus(repository),
        saveWatchlist: SaveWatchlist(repository),
        removeWatchlist: RemoveWatchlist(repository),
      );

      // act
      final expectation = expectLater(
        cubit.stream,
        emitsInOrder([
          const MovieDetailState(movieState: RequestState.Loading),
          MovieDetailState(
            movie: testMovieDetail,
            movieState: RequestState.Loading,
            recommendationState: RequestState.Loading,
          ),
          MovieDetailState(
            movie: testMovieDetail,
            movieState: RequestState.Loaded,
            movieRecommendations: <Movie>[testMovie],
            recommendationState: RequestState.Loaded,
          ),
        ]),
      );
      await cubit.fetchMovieDetail(1);

      // assert
      await expectation;
    },
  );
}
