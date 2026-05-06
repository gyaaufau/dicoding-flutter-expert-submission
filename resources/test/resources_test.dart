import 'package:flutter_test/flutter_test.dart';

import 'package:resources/resources.dart';

void main() {
  test('resource asset path exposed', () {
    expect(ResourceAssets.circleG, 'assets/circle-g.png');
  });
}
