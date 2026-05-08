import 'package:common/common.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tv/tv.dart';

void main() {
  test('tv route names available', () {
    expect(TvRouteNames.home, AppRouteNames.tvHome);
    expect(TvRouteNames.detail, AppRouteNames.tvDetail);
  });
}
