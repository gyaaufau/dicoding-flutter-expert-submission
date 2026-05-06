import 'package:flutter_test/flutter_test.dart';

import 'package:common/common.dart';

void main() {
  test('date formatter convert iso string', () {
    expect('2024-08-17'.toIndonesianDate(), '17 agustus 2024');
  });
}
