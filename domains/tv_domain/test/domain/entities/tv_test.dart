import 'package:tv_domain/tv_domain.dart';
import 'package:tv_domain/tv_domain.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('dto bisa diubah jadi tv entity', () {
    final dto = TvListDto(
      adult: false,
      backdropPath: '/backdrop.jpg',
      genreIds: [1, 2],
      id: 10,
      originCountry: const ['US'],
      originalLanguage: 'en',
      originalName: 'FROM',
      overview: 'overview',
      popularity: 1.0,
      posterPath: '/poster.jpg',
      firstAirDate: '2022-01-01',
      softcore: false,
      name: 'FROM',
      voteAverage: 8.0,
      voteCount: 100,
    );

    final result = dto.toEntity();

    expect(result.name, 'FROM');
    expect(result.id, 10);
  });

  test('tv watchlist punya data dasar', () {
    const result = Tv.watchlist(
      id: 1,
      name: 'Breaking Bad',
      posterPath: '/poster.jpg',
      overview: 'overview',
    );

    expect(result.name, 'Breaking Bad');
    expect(result.genreIds, []);
  });
}
