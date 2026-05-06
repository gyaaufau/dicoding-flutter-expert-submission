import 'package:dependencies/dependencies.dart' show Either;
import 'package:common/common.dart';
import 'package:core/core.dart';
import 'package:tv_domain/src/domain/entities/tv.dart';
import 'package:tv_domain/src/domain/repositories/tv_repository.dart';

class SearchTv extends UseCase<Future<Either<Failure, List<Tv>>>, String> {
  final TvRepository repository;

  SearchTv(this.repository);

  @override
  Future<Either<Failure, List<Tv>>> call(String query) {
    return repository.searchTv(query);
  }
}
