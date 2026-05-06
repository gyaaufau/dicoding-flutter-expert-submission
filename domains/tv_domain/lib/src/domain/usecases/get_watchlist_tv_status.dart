import 'package:core/core.dart';
import 'package:tv_domain/src/domain/repositories/tv_repository.dart';

class GetWatchlistTvStatus extends UseCase<Future<bool>, int> {
  final TvRepository repository;

  GetWatchlistTvStatus(this.repository);

  @override
  Future<bool> call(int params) {
    return repository.isAddedToWatchlist(params);
  }
}
