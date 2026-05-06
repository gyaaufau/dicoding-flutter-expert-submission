import 'package:common/common.dart';
import 'package:core/core.dart';
import 'package:dependencies/dependencies.dart';

import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class GetPopularMovies
    extends UseCase<Future<Either<Failure, List<Movie>>>, NoParams> {
  GetPopularMovies(this.repository);

  final MovieRepository repository;

  @override
  Future<Either<Failure, List<Movie>>> call(NoParams params) {
    return repository.getPopularMovies();
  }
}
