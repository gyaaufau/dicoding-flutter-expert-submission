import 'package:common/common.dart';
import 'package:dependencies/dependencies.dart';
import 'package:movie_domain/movie_domain.dart';

class MovieSearchState extends Equatable {
  const MovieSearchState({
    this.state = RequestState.Empty,
    this.searchResult = const [],
    this.message = '',
  });

  final RequestState state;
  final List<Movie> searchResult;
  final String message;

  MovieSearchState copyWith({
    RequestState? state,
    List<Movie>? searchResult,
    String? message,
  }) {
    return MovieSearchState(
      state: state ?? this.state,
      searchResult: searchResult ?? this.searchResult,
      message: message ?? this.message,
    );
  }

  @override
  List<Object> get props => [state, searchResult, message];
}

class MovieSearchCubit extends Cubit<MovieSearchState> {
  MovieSearchCubit({required this.searchMovies})
    : super(const MovieSearchState());

  final SearchMovies searchMovies;

  Future<void> fetchMovieSearch(String query) async {
    emit(state.copyWith(state: RequestState.Loading));

    final result = await searchMovies.call(query);
    result.fold(
      (failure) => emit(
        state.copyWith(state: RequestState.Error, message: failure.message),
      ),
      (data) =>
          emit(state.copyWith(state: RequestState.Loaded, searchResult: data)),
    );
  }
}
