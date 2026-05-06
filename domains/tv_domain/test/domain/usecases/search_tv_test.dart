import 'package:dartz/dartz.dart';
import 'package:tv_domain/tv_domain.dart';
import 'package:tv_domain/tv_domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late SearchTv usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = SearchTv(mockTvRepository);
  });

  const tQuery = 'Breaking Bad';
  final tTvShows = <Tv>[];

  test('should search tv from repository', () async {
    when(mockTvRepository.searchTv(tQuery))
        .thenAnswer((_) async => Right(tTvShows));

    final result = await usecase.call(tQuery);

    expect(result, Right(tTvShows));
  });
}
