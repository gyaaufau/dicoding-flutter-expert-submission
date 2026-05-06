import 'package:dartz/dartz.dart';
import 'package:tv_domain/tv_domain.dart';
import 'package:tv_domain/tv_domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';
import '../../json_reader.dart';
import 'dart:convert';

void main() {
  late SaveWatchlistTv usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = SaveWatchlistTv(mockTvRepository);
  });

  final testTvDetail = TvDetailDto.fromJson(
    json.decode(readJson('dummy_data/tv_detail.json')),
  ).toEntity();

  test('should save watchlist tv to repository', () async {
    when(mockTvRepository.saveWatchlist(testTvDetail))
        .thenAnswer((_) async => const Right('Added to Watchlist'));

    final result = await usecase.call(testTvDetail);

    verify(mockTvRepository.saveWatchlist(testTvDetail));
    expect(result, const Right('Added to Watchlist'));
  });
}
