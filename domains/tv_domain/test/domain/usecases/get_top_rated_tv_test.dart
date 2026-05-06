import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import 'package:tv_domain/tv_domain.dart';
import 'package:tv_domain/tv_domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTopRatedTv usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetTopRatedTv(mockTvRepository);
  });

  final tTvShows = <Tv>[];

  test('should get top rated tv from repository', () async {
    when(mockTvRepository.getTopRatedTv())
        .thenAnswer((_) async => Right(tTvShows));

    final result = await usecase.call(const NoParams());

    expect(result, Right(tTvShows));
  });
}
