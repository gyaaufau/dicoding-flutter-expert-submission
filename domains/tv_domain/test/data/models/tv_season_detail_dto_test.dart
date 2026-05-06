import 'dart:convert';

import 'package:tv_domain/tv_domain.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  test('bisa baca json detail season tv', () {
    final jsonMap = json.decode(readJson('dummy_data/tv_season_detail.json'));

    final result = TvSeasonDetailDto.fromJson(jsonMap);

    expect(result.name, 'Season 1');
    expect(result.episodes.length, 1);
  });

  test('bisa ubah detail season tv ke json', () {
    final dto = TvSeasonDetailDto.fromJson(
      json.decode(readJson('dummy_data/tv_season_detail.json')),
    );

    final result = dto.toJson();

    expect(result['name'], 'Season 1');
    expect(result['episodes'], isNotEmpty);
  });
}
