import 'package:dartz/dartz.dart';
import 'package:tv_domain/tv_domain.dart';
import 'package:tv_domain/tv_domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvRecommendations usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetTvRecommendations(mockTvRepository);
  });

  const tId = 1;
  final tTvShows = <Tv>[];

  test('should get tv recommendations from repository', () async {
    when(mockTvRepository.getTvRecommendations(tId))
        .thenAnswer((_) async => Right(tTvShows));

    final result = await usecase.call(tId);

    expect(result, Right(tTvShows));
  });
}
