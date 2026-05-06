import 'package:dependencies/dependencies.dart' show Either;
import 'package:common/common.dart';
import 'package:core/core.dart';
import 'package:tv_domain/src/domain/entities/tv_detail.dart';
import 'package:tv_domain/src/domain/repositories/tv_repository.dart';

class RemoveWatchlistTv
    extends UseCase<Future<Either<Failure, String>>, TvDetail> {
  final TvRepository repository;

  RemoveWatchlistTv(this.repository);

  @override
  Future<Either<Failure, String>> call(TvDetail params) {
    return repository.removeWatchlist(params);
  }
}
