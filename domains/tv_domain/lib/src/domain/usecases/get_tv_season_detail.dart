import 'package:dependencies/dependencies.dart' show Either;
import 'package:common/common.dart';
import 'package:core/core.dart';
import 'package:tv_domain/src/domain/entities/tv_season_detail.dart';
import 'package:tv_domain/src/domain/repositories/tv_repository.dart';
import 'package:dependencies/dependencies.dart' show Equatable;

class GetTvSeasonDetail
    extends UseCase<Future<Either<Failure, TvSeasonDetail>>, TvSeasonParams> {
  final TvRepository repository;

  GetTvSeasonDetail(this.repository);

  @override
  Future<Either<Failure, TvSeasonDetail>> call(TvSeasonParams params) {
    return repository.getTvSeasonDetail(params.seriesId, params.seasonNumber);
  }
}

class TvSeasonParams extends Equatable {
  const TvSeasonParams({required this.seriesId, required this.seasonNumber});

  final int seriesId;
  final int seasonNumber;

  @override
  List<Object> get props => [seriesId, seasonNumber];
}
