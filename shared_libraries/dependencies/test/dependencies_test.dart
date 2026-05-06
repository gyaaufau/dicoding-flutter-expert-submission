import 'package:flutter_test/flutter_test.dart';

import 'package:dependencies/dependencies.dart';

void main() {
  test('equatable export available', () {
    expect(const <Object?>[], isA<List<Object?>>());
  });
}
