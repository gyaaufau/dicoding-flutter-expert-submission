import 'package:flutter_test/flutter_test.dart';

import 'package:core/core.dart';

void main() {
  test('no params value object stable', () {
    expect(const NoParams(), const NoParams());
  });
}
