import 'package:dependencies/dependencies.dart' show Either;
import 'package:common/common.dart';
import 'package:core/core.dart';
import 'package:tv_domain/src/domain/entities/tv.dart';
import 'package:tv_domain/src/domain/repositories/tv_repository.dart';

class GetOnTheAirTv
    extends UseCase<Future<Either<Failure, List<Tv>>>, NoParams> {
  final TvRepository repository;

  GetOnTheAirTv(this.repository);

  @override
  Future<Either<Failure, List<Tv>>> call(NoParams params) {
    return repository.getOnTheAirTv();
  }
}
