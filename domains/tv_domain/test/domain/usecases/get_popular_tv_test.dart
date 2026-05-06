import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import 'package:tv_domain/tv_domain.dart';
import 'package:tv_domain/tv_domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetPopularTv usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetPopularTv(mockTvRepository);
  });

  final tTvShows = <Tv>[];

  test('should get list of popular tv shows from repository', () async {
    when(mockTvRepository.getPopularTv())
        .thenAnswer((_) async => Right(tTvShows));

    final result = await usecase.call(const NoParams());

    expect(result, Right(tTvShows));
  });
}
