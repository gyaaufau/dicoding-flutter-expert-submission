import 'package:tv_domain/tv_domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetWatchlistTvStatus usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetWatchlistTvStatus(mockTvRepository);
  });

  test('should get watchlist tv status from repository', () async {
    when(mockTvRepository.isAddedToWatchlist(1)).thenAnswer((_) async => true);

    final result = await usecase.call(1);

    verify(mockTvRepository.isAddedToWatchlist(1));
    expect(result, true);
  });
}
