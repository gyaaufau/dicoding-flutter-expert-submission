import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import 'package:tv_domain/tv_domain.dart';
import 'package:tv_domain/tv_domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetOnTheAirTv usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetOnTheAirTv(mockTvRepository);
  });

  final tTvShows = <Tv>[];

  test('should get on the air tv from repository', () async {
    when(mockTvRepository.getOnTheAirTv())
        .thenAnswer((_) async => Right(tTvShows));

    final result = await usecase.call(const NoParams());

    expect(result, Right(tTvShows));
  });
}
