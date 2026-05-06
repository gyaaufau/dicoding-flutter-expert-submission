import 'package:dependencies/dependencies.dart' show Either;
import 'package:common/common.dart';
import 'package:core/core.dart';
import 'package:tv_domain/src/domain/entities/tv.dart';
import 'package:tv_domain/src/domain/repositories/tv_repository.dart';

class GetTvRecommendations
    extends UseCase<Future<Either<Failure, List<Tv>>>, int> {
  final TvRepository repository;

  GetTvRecommendations(this.repository);

  @override
  Future<Either<Failure, List<Tv>>> call(int id) {
    return repository.getTvRecommendations(id);
  }
}
