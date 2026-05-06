import 'package:common/common.dart';
import 'package:core/core.dart';
import 'package:dependencies/dependencies.dart';

import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class SearchMovies
    extends UseCase<Future<Either<Failure, List<Movie>>>, String> {
  SearchMovies(this.repository);

  final MovieRepository repository;

  @override
  Future<Either<Failure, List<Movie>>> call(String query) {
    return repository.searchMovies(query);
  }
}
