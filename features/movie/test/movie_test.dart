import 'package:flutter_test/flutter_test.dart';

import 'package:movie/movie.dart';

void main() {
  test('movie routes exposed', () {
    expect(HomeMoviePage.ROUTE_NAME, '/movies');
    expect(MovieDetailPage.ROUTE_NAME, '/detail');
  });
}
