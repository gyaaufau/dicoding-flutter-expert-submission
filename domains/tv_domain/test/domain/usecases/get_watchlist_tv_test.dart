import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import 'package:tv_domain/tv_domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetWatchlistTv usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetWatchlistTv(mockTvRepository);
  });

  test('should get watchlist tv from repository', () async {
    when(mockTvRepository.getWatchlistTv())
        .thenAnswer((_) async => Right([testWatchlistTv]));

    final result = await usecase.call(const NoParams());
    final resultList = result.getOrElse(() => []);

    verify(mockTvRepository.getWatchlistTv());
    expect(resultList, [testWatchlistTv]);
  });
}
