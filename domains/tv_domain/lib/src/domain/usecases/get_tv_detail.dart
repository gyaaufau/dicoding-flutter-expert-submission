import 'package:dependencies/dependencies.dart' show Either;
import 'package:common/common.dart';
import 'package:core/core.dart';
import 'package:tv_domain/src/domain/entities/tv_detail.dart';
import 'package:tv_domain/src/domain/repositories/tv_repository.dart';

class GetTvDetail extends UseCase<Future<Either<Failure, TvDetail>>, int> {
  final TvRepository repository;

  GetTvDetail(this.repository);

  @override
  Future<Either<Failure, TvDetail>> call(int id) {
    return repository.getTvDetail(id);
  }
}
