import 'package:flutter_test/flutter_test.dart';

import 'package:tv/tv.dart';

void main() {
  test('tv route names available', () {
    expect(TvRouteNames.home, 'tv');
    expect(TvRouteNames.detail, 'tv-detail');
  });
}
