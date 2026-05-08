import 'dart:io';

import 'package:common/common.dart';
import 'package:core/core.dart';
import 'package:dependencies/dependencies.dart';
import 'package:tv_domain/src/data/datasources/tv_local_data_source.dart';
import 'package:tv_domain/src/data/models/tv_table.dart';
import 'package:tv_domain/src/data/datasources/tv_remote_data_source.dart';
import 'package:tv_domain/src/domain/entities/tv.dart';
import 'package:tv_domain/src/domain/entities/tv_detail.dart';
import 'package:tv_domain/src/domain/entities/tv_season_detail.dart';
import 'package:tv_domain/src/domain/repositories/tv_repository.dart';

class TvRepositoryImpl implements TvRepository {
  final TvRemoteDataSource remoteDataSource;
  final TvLocalDataSource localDataSource;
  final CrashReporter? crashReporter;

  TvRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    this.crashReporter,
  });

  @override
  Future<Either<Failure, List<Tv>>> getOnTheAirTv() async {
    try {
      final result = await remoteDataSource.getOnTheAirTv();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, List<Tv>>> getPopularTv() async {
    try {
      final result = await remoteDataSource.getPopularTv();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, List<Tv>>> getTopRatedTv() async {
    try {
      final result = await remoteDataSource.getTopRatedTv();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, TvDetail>> getTvDetail(int id) async {
    try {
      final result = await remoteDataSource.getTvDetail(id);
      return Right(result.toEntity());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, List<Tv>>> getTvRecommendations(int id) async {
    try {
      final result = await remoteDataSource.getTvRecommendations(id);
      return Right(result.map((model) => model.toEntity()).toList());
    } catch (e, s) {
      await crashReporter?.recordNonFatal(
        e,
        s,
        reason: 'unexpected_get_tv_recommendations_error',
        keys: {
          'feature': 'tv',
          'entity_id': id,
          'repository_method': 'getTvRecommendations',
        },
      );
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TvSeasonDetail>> getTvSeasonDetail(
    int seriesId,
    int seasonNumber,
  ) async {
    try {
      final result = await remoteDataSource.getTvSeasonDetail(
        seriesId,
        seasonNumber,
      );
      return Right(result.toEntity());
    } catch (e, s) {
      await crashReporter?.recordNonFatal(
        e,
        s,
        reason: 'unexpected_get_tv_season_detail_error',
        keys: {
          'feature': 'tv',
          'entity_id': seriesId,
          'season_number': seasonNumber,
          'repository_method': 'getTvSeasonDetail',
        },
      );
      return Left(ServerFailure(''));
    }
  }

  @override
  Future<Either<Failure, List<Tv>>> searchTv(String query) async {
    try {
      final result = await remoteDataSource.searchTv(query);
      return Right(result.map((model) => model.toEntity()).toList());
    } catch (e, s) {
      await crashReporter?.recordNonFatal(
        e,
        s,
        reason: 'unexpected_search_tv_error',
        keys: {
          'feature': 'tv',
          'query_length': query.length,
          'repository_method': 'searchTv',
        },
      );
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> saveWatchlist(TvDetail tv) async {
    try {
      final result = await localDataSource.insertWatchlist(
        TvTable.fromEntity(tv),
      );
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, String>> removeWatchlist(TvDetail tv) async {
    try {
      final result = await localDataSource.removeWatchlist(
        TvTable.fromEntity(tv),
      );
      return Right(result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<bool> isAddedToWatchlist(int id) async {
    final result = await localDataSource.getTvById(id);
    return result != null;
  }

  @override
  Future<Either<Failure, List<Tv>>> getWatchlistTv() async {
    final result = await localDataSource.getWatchlistTv();
    return Right(result.map((data) => data.toEntity()).toList());
  }
}
