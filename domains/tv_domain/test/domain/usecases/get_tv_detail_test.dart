import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:tv_domain/tv_domain.dart';
import 'package:tv_domain/tv_domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';
import '../../json_reader.dart';

void main() {
  late GetTvDetail usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetTvDetail(mockTvRepository);
  });

  const tId = 1;
  final tTvDetail = TvDetailDto.fromJson(
    json.decode(readJson('dummy_data/tv_detail.json')),
  ).toEntity();

  test('should get tv detail from repository', () async {
    when(mockTvRepository.getTvDetail(tId))
        .thenAnswer((_) async => Right(tTvDetail));

    final result = await usecase.call(tId);

    expect(result, Right(tTvDetail));
  });
}
