import 'dart:convert';

import 'package:tv_domain/tv_domain.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  test('bisa baca json detail tv', () {
    final jsonMap = json.decode(readJson('dummy_data/tv_detail.json'));

    final result = TvDetailDto.fromJson(jsonMap);

    expect(result.id, 1396);
    expect(result.name, 'Breaking Bad');
    expect(result.seasons.length, 2);
  });

  test('bisa ubah detail tv ke json', () {
    final dto = TvDetailDto.fromJson(
      json.decode(readJson('dummy_data/tv_detail.json')),
    );

    final result = dto.toJson();

    expect(result['id'], 1396);
    expect(result['name'], 'Breaking Bad');
    expect(result['seasons'], isNotEmpty);
  });
}
