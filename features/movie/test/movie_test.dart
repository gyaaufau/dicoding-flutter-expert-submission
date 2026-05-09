import 'package:common/common.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:movie/movie.dart';

void main() {
  test('movie routes exposed', () {
    expect(HomeMoviePage.ROUTE_NAME, AppRoutePaths.movies);
    expect(MovieDetailPage.ROUTE_NAME, AppRoutePaths.moviesDetailPattern);
  });
}
