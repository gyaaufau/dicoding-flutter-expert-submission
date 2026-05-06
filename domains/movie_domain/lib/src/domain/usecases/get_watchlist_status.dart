import 'package:core/core.dart';

import '../repositories/movie_repository.dart';

class GetWatchListStatus extends UseCase<Future<bool>, int> {
  GetWatchListStatus(this.repository);

  final MovieRepository repository;

  @override
  Future<bool> call(int id) async {
    return repository.isAddedToWatchlist(id);
  }
}
