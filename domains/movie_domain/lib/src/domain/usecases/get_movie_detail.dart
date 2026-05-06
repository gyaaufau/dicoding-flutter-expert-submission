import 'package:common/common.dart';
import 'package:core/core.dart';
import 'package:dependencies/dependencies.dart';

import '../entities/movie_detail.dart';
import '../repositories/movie_repository.dart';

class GetMovieDetail
    extends UseCase<Future<Either<Failure, MovieDetail>>, int> {
  GetMovieDetail(this.repository);

  final MovieRepository repository;

  @override
  Future<Either<Failure, MovieDetail>> call(int id) {
    return repository.getMovieDetail(id);
  }
}
