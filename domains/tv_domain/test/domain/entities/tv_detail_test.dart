import 'dart:convert';

import 'package:tv_domain/tv_domain.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  test('dto bisa diubah jadi tv detail entity', () {
    final dto = TvDetailDto.fromJson(
      json.decode(readJson('dummy_data/tv_detail.json')),
    );

    final result = dto.toEntity();

    expect(result.id, 1396);
    expect(result.name, 'Breaking Bad');
    expect(result.createdBy.first.name, 'Vince Gilligan');
    expect(result.networks.first.name, 'AMC');
    expect(result.seasons.first.name, 'Specials');
  });
}
