import 'package:core/core.dart';
import 'package:dependencies/dependencies.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeChecker implements DataConnectionChecker {
  FakeChecker(this.value);

  final bool value;

  @override
  Future<bool> get hasConnection async => value;

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  tearDown(() async {
    await locator.reset();
  });

  test('network info should forward connection status', () async {
    // arrange
    final networkInfo = NetworkInfoImpl(FakeChecker(true));

    // act
    final result = await networkInfo.isConnected;

    // assert
    expect(result, true);
  });

  test('paged response dto should map json and back', () {
    // arrange
    final dto = PagedResponseDto<int>.fromJson({
      'page': 1,
      'results': [
        {'value': 1},
        {'value': 2},
      ],
      'total_pages': 2,
      'total_results': 2,
    }, (json) => json['value'] as int, where: (item) => item > 1);

    // act
    final json = dto.toPagedJson((item) => {'value': item});

    // assert
    expect(dto.results, [2]);
    expect(json['total_pages'], 2);
    expect(json['results'], [
      {'value': 2},
    ]);
  });

  test('core injection should register shared dependencies', () {
    // arrange
    registerCoreDependencies();

    // assert
    expect(locator.isRegistered<NetworkInfo>(), true);
    expect(locator.isRegistered<Client>(), true);
    expect(locator.isRegistered<DataConnectionChecker>(), true);
  });
}
