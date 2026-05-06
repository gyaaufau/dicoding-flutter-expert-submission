import 'package:common/common.dart';
import 'package:core/core.dart';
import 'package:dependencies/dependencies.dart';
import 'package:movie_domain/movie_domain.dart';

class WatchlistMovieState extends Equatable {
  const WatchlistMovieState({
    this.watchlistMovies = const [],
    this.watchlistState = RequestState.Empty,
    this.message = '',
  });

  final List<Movie> watchlistMovies;
  final RequestState watchlistState;
  final String message;

  WatchlistMovieState copyWith({
    List<Movie>? watchlistMovies,
    RequestState? watchlistState,
    String? message,
  }) {
    return WatchlistMovieState(
      watchlistMovies: watchlistMovies ?? this.watchlistMovies,
      watchlistState: watchlistState ?? this.watchlistState,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [watchlistMovies, watchlistState, message];
}

class WatchlistMovieCubit extends Cubit<WatchlistMovieState> {
  WatchlistMovieCubit({required this.getWatchlistMovies})
    : super(const WatchlistMovieState());

  final GetWatchlistMovies getWatchlistMovies;

  Future<void> fetchWatchlistMovies() async {
    emit(state.copyWith(watchlistState: RequestState.Loading));

    final result = await getWatchlistMovies.call(const NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(
          watchlistState: RequestState.Error,
          message: failure.message,
        ),
      ),
      (moviesData) => emit(
        state.copyWith(
          watchlistState: RequestState.Loaded,
          watchlistMovies: moviesData,
        ),
      ),
    );
  }
}
