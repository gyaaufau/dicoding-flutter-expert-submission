import 'package:common/common.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:watchlist/watchlist.dart';

void main() {
  test('watchlist route available', () {
    expect(WatchlistMoviesPage.ROUTE_NAME, AppRoutePaths.watchlist);
  });
}
