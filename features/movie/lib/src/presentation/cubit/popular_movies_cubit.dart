import 'package:common/common.dart';
import 'package:core/core.dart';
import 'package:dependencies/dependencies.dart';
import 'package:movie_domain/movie_domain.dart';

class PopularMoviesState extends Equatable {
  const PopularMoviesState({
    this.state = RequestState.Empty,
    this.movies = const [],
    this.message = '',
  });

  final RequestState state;
  final List<Movie> movies;
  final String message;

  PopularMoviesState copyWith({
    RequestState? state,
    List<Movie>? movies,
    String? message,
  }) {
    return PopularMoviesState(
      state: state ?? this.state,
      movies: movies ?? this.movies,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [state, movies, message];
}

class PopularMoviesCubit extends Cubit<PopularMoviesState> {
  PopularMoviesCubit(this.getPopularMovies) : super(const PopularMoviesState());

  final GetPopularMovies getPopularMovies;

  Future<void> fetchPopularMovies() async {
    emit(state.copyWith(state: RequestState.Loading));

    final result = await getPopularMovies.call(const NoParams());
    result.fold(
      (failure) => emit(
        state.copyWith(state: RequestState.Error, message: failure.message),
      ),
      (moviesData) =>
          emit(state.copyWith(state: RequestState.Loaded, movies: moviesData)),
    );
  }
}
