import 'dart:convert';

import 'package:tv_domain/tv_domain.dart';
import 'package:tv_domain/tv_domain.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  final tvDetail = TvDetailDto.fromJson(
    json.decode(readJson('dummy_data/tv_detail.json')),
  ).toEntity();

  test('bisa buat tv table dari entity', () {
    final result = TvTable.fromEntity(tvDetail);

    expect(result.id, 1396);
    expect(result.name, 'Breaking Bad');
  });

  test('bisa buat tv table dari map title', () {
    final result = TvTable.fromMap({
      'id': 1,
      'title': 'FROM',
      'posterPath': '/poster.jpg',
      'overview': 'overview',
    });

    expect(result.name, 'FROM');
    expect(result.id, 1);
  });

  test('bisa buat tv table dari map name', () {
    final result = TvTable.fromMap({
      'id': 2,
      'name': 'Better Call Saul',
      'posterPath': '/poster.jpg',
      'overview': 'overview',
    });

    expect(result.name, 'Better Call Saul');
    expect(result.id, 2);
  });

  test('bisa ubah tv table ke json', () {
    const table = TvTable(
      id: 1,
      name: 'FROM',
      posterPath: '/poster.jpg',
      overview: 'overview',
    );

    final result = table.toJson();

    expect(result['title'], 'FROM');
    expect(result['id'], 1);
  });

  test('bisa ubah tv table ke entity', () {
    const table = TvTable(
      id: 1,
      name: 'FROM',
      posterPath: '/poster.jpg',
      overview: 'overview',
    );

    final result = table.toEntity();

    expect(result.name, 'FROM');
    expect(result.id, 1);
  });
}
