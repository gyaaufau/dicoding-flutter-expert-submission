import 'package:common/common.dart';
import 'package:core/core.dart';
import 'package:dependencies/dependencies.dart';

import '../entities/movie_detail.dart';
import '../repositories/movie_repository.dart';

class SaveWatchlist
    extends UseCase<Future<Either<Failure, String>>, MovieDetail> {
  SaveWatchlist(this.repository);

  final MovieRepository repository;

  @override
  Future<Either<Failure, String>> call(MovieDetail movie) {
    return repository.saveWatchlist(movie);
  }
}
