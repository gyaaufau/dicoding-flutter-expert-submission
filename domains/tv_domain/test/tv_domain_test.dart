import 'package:flutter_test/flutter_test.dart';

import 'package:tv_domain/tv_domain.dart';

void main() {
  test('tv watchlist entity available', () {
    const tv = Tv.watchlist(
      id: 1,
      name: 'name',
      posterPath: 'poster',
      overview: 'overview',
    );

    expect(tv.id, 1);
  });
}
