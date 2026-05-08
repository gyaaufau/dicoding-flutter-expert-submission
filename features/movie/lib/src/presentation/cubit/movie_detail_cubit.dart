import 'dart:async';

import 'package:common/common.dart';
import 'package:core/core.dart';
import 'package:dependencies/dependencies.dart';
import 'package:movie_domain/movie_domain.dart';

class MovieDetailState extends Equatable {
  const MovieDetailState({
    this.movie,
    this.movieState = RequestState.Empty,
    this.movieRecommendations = const [],
    this.recommendationState = RequestState.Empty,
    this.message = '',
    this.isAddedToWatchlist = false,
    this.watchlistMessage = '',
  });

  final MovieDetail? movie;
  final RequestState movieState;
  final List<Movie> movieRecommendations;
  final RequestState recommendationState;
  final String message;
  final bool isAddedToWatchlist;
  final String watchlistMessage;

  MovieDetailState copyWith({
    MovieDetail? movie,
    bool clearMovie = false,
    RequestState? movieState,
    List<Movie>? movieRecommendations,
    RequestState? recommendationState,
    String? message,
    bool? isAddedToWatchlist,
    String? watchlistMessage,
  }) {
    return MovieDetailState(
      movie: clearMovie ? null : (movie ?? this.movie),
      movieState: movieState ?? this.movieState,
      movieRecommendations: movieRecommendations ?? this.movieRecommendations,
      recommendationState: recommendationState ?? this.recommendationState,
      message: message ?? this.message,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
    );
  }

  @override
  List<Object?> get props => [
    movie,
    movieState,
    movieRecommendations,
    recommendationState,
    message,
    isAddedToWatchlist,
    watchlistMessage,
  ];
}

class MovieDetailCubit extends Cubit<MovieDetailState> {
  MovieDetailCubit({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(const MovieDetailState());

  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  Future<void> fetchMovieDetail(int id) async {
    _recordMovieBreadcrumb(
      'Open movie detail',
      keys: {'feature': 'movie', 'entity_id': id},
    );
    emit(state.copyWith(movieState: RequestState.Loading));

    final detailResult = await getMovieDetail.call(id);
    final recommendationResult = await getMovieRecommendations.call(id);

    detailResult.fold(
      (failure) => emit(
        state.copyWith(
          movieState: RequestState.Error,
          message: failure.message,
        ),
      ),
      (movie) {
        _logMovieAnalyticsEvent(
          'movie_detail_viewed',
          params: {
            'feature': 'movie',
            'content_type': 'movie',
            'content_id': movie.id,
          },
        );
        emit(
          state.copyWith(
            movie: movie,
            recommendationState: RequestState.Loading,
          ),
        );

        recommendationResult.fold(
          (failure) => emit(
            state.copyWith(
              movieState: RequestState.Loaded,
              recommendationState: RequestState.Error,
              message: failure.message,
            ),
          ),
          (movies) => emit(
            state.copyWith(
              movieState: RequestState.Loaded,
              recommendationState: RequestState.Loaded,
              movieRecommendations: movies,
            ),
          ),
        );
      },
    );
  }

  Future<void> addWatchlist(MovieDetail movie) async {
    _recordMovieBreadcrumb(
      'Add movie watchlist',
      keys: {'feature': 'movie', 'entity_id': movie.id},
    );
    final result = await saveWatchlist.call(movie);

    final message = result.fold(
      (failure) => failure.message,
      (successMessage) => successMessage,
    );

    if (message == watchlistAddSuccessMessage) {
      _logMovieAnalyticsEvent(
        'watchlist_added',
        params: {
          'feature': 'movie',
          'content_type': 'movie',
          'content_id': movie.id,
        },
      );
    }

    emit(state.copyWith(watchlistMessage: message));
    await loadWatchlistStatus(movie.id);
  }

  Future<void> removeFromWatchlist(MovieDetail movie) async {
    _recordMovieBreadcrumb(
      'Remove movie watchlist',
      keys: {'feature': 'movie', 'entity_id': movie.id},
    );
    final result = await removeWatchlist.call(movie);

    final message = result.fold(
      (failure) => failure.message,
      (successMessage) => successMessage,
    );

    if (message == watchlistRemoveSuccessMessage) {
      _logMovieAnalyticsEvent(
        'watchlist_removed',
        params: {
          'feature': 'movie',
          'content_type': 'movie',
          'content_id': movie.id,
        },
      );
    }

    emit(state.copyWith(watchlistMessage: message));
    await loadWatchlistStatus(movie.id);
  }

  Future<void> loadWatchlistStatus(int id) async {
    final result = await getWatchListStatus.call(id);
    emit(state.copyWith(isAddedToWatchlist: result));
  }
}

void _recordMovieBreadcrumb(
  String message, {
  Map<String, Object?> keys = const {},
}) {
  if (!locator.isRegistered<CrashReporter>()) {
    return;
  }
  unawaited(locator<CrashReporter>().recordBreadcrumb(message, keys: keys));
}

void _logMovieAnalyticsEvent(
  String name, {
  Map<String, Object?> params = const {},
}) {
  if (!locator.isRegistered<AnalyticsTracker>()) {
    return;
  }
  unawaited(locator<AnalyticsTracker>().logEvent(name, params: params));
}
