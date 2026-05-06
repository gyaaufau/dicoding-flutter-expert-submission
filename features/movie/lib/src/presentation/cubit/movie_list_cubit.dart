import 'package:common/common.dart';
import 'package:core/core.dart';
import 'package:dependencies/dependencies.dart';
import 'package:movie_domain/movie_domain.dart';

class MovieListState extends Equatable {
  const MovieListState({
    this.nowPlayingMovies = const [],
    this.nowPlayingState = RequestState.Empty,
    this.popularMovies = const [],
    this.popularMoviesState = RequestState.Empty,
    this.topRatedMovies = const [],
    this.topRatedMoviesState = RequestState.Empty,
    this.message = '',
  });

  final List<Movie> nowPlayingMovies;
  final RequestState nowPlayingState;
  final List<Movie> popularMovies;
  final RequestState popularMoviesState;
  final List<Movie> topRatedMovies;
  final RequestState topRatedMoviesState;
  final String message;

  MovieListState copyWith({
    List<Movie>? nowPlayingMovies,
    RequestState? nowPlayingState,
    List<Movie>? popularMovies,
    RequestState? popularMoviesState,
    List<Movie>? topRatedMovies,
    RequestState? topRatedMoviesState,
    String? message,
  }) {
    return MovieListState(
      nowPlayingMovies: nowPlayingMovies ?? this.nowPlayingMovies,
      nowPlayingState: nowPlayingState ?? this.nowPlayingState,
      popularMovies: popularMovies ?? this.popularMovies,
      popularMoviesState: popularMoviesState ?? this.popularMoviesState,
      topRatedMovies: topRatedMovies ?? this.topRatedMovies,
      topRatedMoviesState: topRatedMoviesState ?? this.topRatedMoviesState,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [
    nowPlayingMovies,
    nowPlayingState,
    popularMovies,
    popularMoviesState,
    topRatedMovies,
    topRatedMoviesState,
    message,
  ];
}

class MovieListCubit extends Cubit<MovieListState> {
  MovieListCubit({
    required this.getNowPlayingMovies,
    required this.getPopularMovies,
    required this.getTopRatedMovies,
  }) : super(const MovieListState());

  final GetNowPlayingMovies getNowPlayingMovies;
  final GetPopularMovies getPopularMovies;
  final GetTopRatedMovies getTopRatedMovies;

  Future<void> fetchNowPlayingMovies() async {
    emit(state.copyWith(nowPlayingState: RequestState.Loading));

    final result = await getNowPlayingMovies.call(const NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(
          nowPlayingState: RequestState.Error,
          message: failure.message,
        ),
      ),
      (moviesData) => emit(
        state.copyWith(
          nowPlayingState: RequestState.Loaded,
          nowPlayingMovies: moviesData,
        ),
      ),
    );
  }

  Future<void> fetchPopularMovies() async {
    emit(state.copyWith(popularMoviesState: RequestState.Loading));

    final result = await getPopularMovies.call(const NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(
          popularMoviesState: RequestState.Error,
          message: failure.message,
        ),
      ),
      (moviesData) => emit(
        state.copyWith(
          popularMoviesState: RequestState.Loaded,
          popularMovies: moviesData,
        ),
      ),
    );
  }

  Future<void> fetchTopRatedMovies() async {
    emit(state.copyWith(topRatedMoviesState: RequestState.Loading));

    final result = await getTopRatedMovies.call(const NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(
          topRatedMoviesState: RequestState.Error,
          message: failure.message,
        ),
      ),
      (moviesData) => emit(
        state.copyWith(
          topRatedMoviesState: RequestState.Loaded,
          topRatedMovies: moviesData,
        ),
      ),
    );
  }
}
