import 'package:flutter_test/flutter_test.dart';

import 'package:movie_domain/movie_domain.dart';

void main() {
  test('movie watchlist entity available', () {
    final movie = Movie.watchlist(
      id: 1,
      overview: 'overview',
      posterPath: 'poster',
      title: 'title',
    );

    expect(movie.id, 1);
  });
}
