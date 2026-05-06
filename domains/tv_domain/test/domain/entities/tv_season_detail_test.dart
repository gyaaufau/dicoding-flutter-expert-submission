import 'dart:convert';

import 'package:tv_domain/tv_domain.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  test('dto bisa diubah jadi season detail entity', () {
    final dto = TvSeasonDetailDto.fromJson(
      json.decode(readJson('dummy_data/tv_season_detail.json')),
    );

    final result = dto.toEntity();

    expect(result.name, 'Season 1');
    expect(result.episodes.first.name, 'Winter Is Coming');
    expect(result.networks.first.name, 'HBO');
    expect(result.episodes.first.crew.first.name, 'David Benioff');
  });
}
