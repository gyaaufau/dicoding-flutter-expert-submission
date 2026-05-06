import 'package:dependencies/dependencies.dart' show Either;
import 'package:common/common.dart';
import 'package:tv_domain/src/domain/entities/tv.dart';
import 'package:tv_domain/src/domain/entities/tv_detail.dart';
import 'package:tv_domain/src/domain/entities/tv_season_detail.dart';

abstract class TvRepository {
  Future<Either<Failure, List<Tv>>> getOnTheAirTv();
  Future<Either<Failure, List<Tv>>> getPopularTv();
  Future<Either<Failure, List<Tv>>> getTopRatedTv();
  Future<Either<Failure, TvDetail>> getTvDetail(int id);
  Future<Either<Failure, TvSeasonDetail>> getTvSeasonDetail(
    int seriesId,
    int seasonNumber,
  );
  Future<Either<Failure, List<Tv>>> getTvRecommendations(int id);
  Future<Either<Failure, List<Tv>>> searchTv(String query);
  Future<Either<Failure, String>> saveWatchlist(TvDetail tv);
  Future<Either<Failure, String>> removeWatchlist(TvDetail tv);
  Future<bool> isAddedToWatchlist(int id);
  Future<Either<Failure, List<Tv>>> getWatchlistTv();
}
