import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:tv_domain/tv_domain.dart';
import 'package:tv_domain/tv_domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';
import '../../json_reader.dart';

void main() {
  late RemoveWatchlistTv usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = RemoveWatchlistTv(mockTvRepository);
  });

  final testTvDetail = TvDetailDto.fromJson(
    json.decode(readJson('dummy_data/tv_detail.json')),
  ).toEntity();

  test('should remove watchlist tv from repository', () async {
    when(mockTvRepository.removeWatchlist(testTvDetail))
        .thenAnswer((_) async => const Right('Removed from Watchlist'));

    final result = await usecase.call(testTvDetail);

    verify(mockTvRepository.removeWatchlist(testTvDetail));
    expect(result, const Right('Removed from Watchlist'));
  });
}
