import 'package:common/common.dart';
import 'package:core/core.dart';
import 'package:dependencies/dependencies.dart';

import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class GetMovieRecommendations
    extends UseCase<Future<Either<Failure, List<Movie>>>, int> {
  GetMovieRecommendations(this.repository);

  final MovieRepository repository;

  @override
  Future<Either<Failure, List<Movie>>> call(int id) {
    return repository.getMovieRecommendations(id);
  }
}
