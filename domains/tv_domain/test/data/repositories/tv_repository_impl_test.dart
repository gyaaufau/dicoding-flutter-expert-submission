import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:common/common.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_domain/tv_domain.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';
import '../../json_reader.dart';

void main() {
  late TvRepositoryImpl repository;
  late MockTvRemoteDataSource mockRemoteDataSource;
  late MockTvLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockTvRemoteDataSource();
    mockLocalDataSource = MockTvLocalDataSource();
    repository = TvRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  final tTvListDto = (json.decode(readJson('dummy_data/tv_on_the_air.json'))
          as Map<String, dynamic>)['results'] as List<dynamic>;
  final tvDtoList = tTvListDto
      .map((item) => TvListDto.fromJson(item as Map<String, dynamic>))
      .toList();
  final tTvList = tvDtoList.map((dto) => dto.toEntity()).toList();
  final tTvDetail = TvDetailDto.fromJson(
    json.decode(readJson('dummy_data/tv_detail.json')),
  );
  final tTvSeasonDetail = TvSeasonDetailDto.fromJson(
    json.decode(readJson('dummy_data/tv_season_detail.json')),
  );
  final tTvTable = TvTable(
    id: 1,
    name: 'title',
    posterPath: 'posterPath',
    overview: 'overview',
  );

  test('should return tv list when remote data source call is successful', () async {
    // arrange
    when(mockRemoteDataSource.getOnTheAirTv())
        .thenAnswer((_) async => tvDtoList);

    // act
    final result = await repository.getOnTheAirTv();

    // assert
    verify(mockRemoteDataSource.getOnTheAirTv());
    final resultList = result.getOrElse(() => []);
    expect(resultList, tTvList);
  });

  test('should return ServerFailure when remote data source throws server exception', () async {
    // arrange
    when(mockRemoteDataSource.getPopularTv()).thenThrow(ServerException());

    // act
    final result = await repository.getPopularTv();

    // assert
    expect(result, Left(ServerFailure('')));
  });

  test('should return ConnectionFailure when remote data source throws socket exception', () async {
    // arrange
    when(mockRemoteDataSource.getTopRatedTv()).thenThrow(const SocketException('Failed to connect to the network'));

    // act
    final result = await repository.getTopRatedTv();

    // assert
    expect(result, Left(ConnectionFailure('Failed to connect to the network')));
  });

  test('should return tv detail when call to data source is successful', () async {
    // arrange
    when(mockRemoteDataSource.getTvDetail(1)).thenAnswer((_) async => tTvDetail);

    // act
    final result = await repository.getTvDetail(1);

    // assert
    expect(result, Right(tTvDetail.toEntity()));
  });

  test('should return tv season detail when call to data source is successful', () async {
    // arrange
    when(mockRemoteDataSource.getTvSeasonDetail(1, 1))
        .thenAnswer((_) async => tTvSeasonDetail);

    // act
    final result = await repository.getTvSeasonDetail(1, 1);

    // assert
    expect(result, Right(tTvSeasonDetail.toEntity()));
  });

  test('should return watchlist status when data is found', () async {
    // arrange
    when(mockLocalDataSource.getTvById(1)).thenAnswer((_) async => tTvTable);

    // act
    final result = await repository.isAddedToWatchlist(1);

    // assert
    expect(result, true);
  });

  test('should return watchlist tv list', () async {
    // arrange
    when(mockLocalDataSource.getWatchlistTv())
        .thenAnswer((_) async => <TvTable>[tTvTable]);

    // act
    final result = await repository.getWatchlistTv();

    // assert
    final resultList = result.getOrElse(() => []);
    expect(resultList, <Tv>[testWatchlistTv]);
  });
}
