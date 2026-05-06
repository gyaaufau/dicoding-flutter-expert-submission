import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:tv_domain/tv_domain.dart';
import 'package:tv_domain/tv_domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';
import '../../json_reader.dart';

void main() {
  late GetTvSeasonDetail usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetTvSeasonDetail(mockTvRepository);
  });

  const params = TvSeasonParams(seriesId: 1, seasonNumber: 1);
  final tTvSeasonDetail = TvSeasonDetailDto.fromJson(
    json.decode(readJson('dummy_data/tv_season_detail.json')),
  ).toEntity();

  test('should get tv season detail from repository', () async {
    when(mockTvRepository.getTvSeasonDetail(
            params.seriesId, params.seasonNumber))
        .thenAnswer((_) async => Right(tTvSeasonDetail));

    final result = await usecase.call(params);

    expect(result, Right(tTvSeasonDetail));
  });
}
