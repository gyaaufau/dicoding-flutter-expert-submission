import 'package:tv_domain/tv_domain.dart';
import 'package:tv_domain/tv_domain.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('bisa ubah tv dto ke entity', () {
    final dto = TvListDto(
      adult: false,
      backdropPath: 'backdropPath',
      genreIds: [9648, 18, 10765],
      id: 124364,
      originCountry: ['US'],
      originalLanguage: 'en',
      originalName: 'FROM',
      overview: 'overview',
      popularity: 644.1358,
      posterPath: 'posterPath',
      firstAirDate: '2022-02-20',
      softcore: false,
      name: 'FROM',
      voteAverage: 8.168,
      voteCount: 2637,
    );

    final result = dto.toEntity();

    expect(result.name, 'FROM');
    expect(result.id, 124364);
  });

  test('bisa buat tv dto dari entity', () {
    final tv = Tv.watchlist(
      id: 1,
      name: 'FROM',
      posterPath: '/poster.jpg',
      overview: 'overview',
    );

    final result = TvListDto.fromEntity(tv);

    expect(result.name, 'FROM');
    expect(result.id, 1);
  });
}
