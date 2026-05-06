import 'dart:convert';

import 'package:tv_domain/tv_domain.dart';
import 'package:core/core.dart';
import 'package:tv_domain/tv_domain.dart';
import 'package:tv_domain/tv_domain.dart';
import 'package:tv_domain/tv_domain.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../../helpers/test_helper.mocks.dart';
import '../../../json_reader.dart';

void main() {
  const apiKey = TvRemoteDataSourceImpl.apiKey;
  const baseUrl = TvRemoteDataSourceImpl.baseUrl;

  late TvRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = TvRemoteDataSourceImpl(client: mockHttpClient);
  });

  http.Response jsonResponse(String path) => http.Response.bytes(
        utf8.encode(readJson(path)),
        200,
        headers: {'content-type': 'application/json; charset=utf-8'},
      );

  test('getOnTheAirTv jalan', () async {
    final expected = PagedResponseDto<TvListDto>.fromJson(
      json.decode(readJson('dummy_data/tv_on_the_air.json')),
      TvListDto.fromJson,
      where: (item) => item.posterPath != null,
    ).results;

    when(mockHttpClient.get(Uri.parse('$baseUrl/tv/on_the_air?$apiKey')))
        .thenAnswer((_) async => jsonResponse('dummy_data/tv_on_the_air.json'));

    final result = await dataSource.getOnTheAirTv();

    expect(result, expected);
  });

  test('getPopularTv jalan', () async {
    final expected = PagedResponseDto<TvListDto>.fromJson(
      json.decode(readJson('dummy_data/popular_tv.json')),
      TvListDto.fromJson,
      where: (item) => item.posterPath != null,
    ).results;

    when(mockHttpClient.get(Uri.parse('$baseUrl/tv/popular?$apiKey')))
        .thenAnswer((_) async => jsonResponse('dummy_data/popular_tv.json'));

    final result = await dataSource.getPopularTv();

    expect(result, expected);
  });

  test('getTopRatedTv jalan', () async {
    final expected = PagedResponseDto<TvListDto>.fromJson(
      json.decode(readJson('dummy_data/top_rated_tv.json')),
      TvListDto.fromJson,
      where: (item) => item.posterPath != null,
    ).results;

    when(mockHttpClient.get(Uri.parse('$baseUrl/tv/top_rated?$apiKey')))
        .thenAnswer((_) async => jsonResponse('dummy_data/top_rated_tv.json'));

    final result = await dataSource.getTopRatedTv();

    expect(result, expected);
  });

  test('getTvDetail jalan', () async {
    const id = 1396;
    final expected = TvDetailDto.fromJson(
      json.decode(readJson('dummy_data/tv_detail.json')),
    );

    when(mockHttpClient.get(Uri.parse('$baseUrl/tv/$id?$apiKey')))
        .thenAnswer((_) async => jsonResponse('dummy_data/tv_detail.json'));

    final result = await dataSource.getTvDetail(id);

    expect(result, expected);
  });

  test('getTvSeasonDetail jalan', () async {
    const seriesId = 1399;
    const seasonNumber = 1;
    final expected = TvSeasonDetailDto.fromJson(
      json.decode(readJson('dummy_data/tv_season_detail.json')),
    );

    when(mockHttpClient.get(
      Uri.parse('$baseUrl/tv/$seriesId/season/$seasonNumber?$apiKey'),
    )).thenAnswer(
      (_) async => jsonResponse('dummy_data/tv_season_detail.json'),
    );

    final result = await dataSource.getTvSeasonDetail(seriesId, seasonNumber);

    expect(result, expected);
  });

  test('getTvRecommendations jalan', () async {
    const id = 1396;
    final expected = PagedResponseDto<TvListDto>.fromJson(
      json.decode(readJson('dummy_data/popular_tv.json')),
      TvListDto.fromJson,
      where: (item) => item.posterPath != null,
    ).results;

    when(mockHttpClient
            .get(Uri.parse('$baseUrl/tv/$id/recommendations?$apiKey')))
        .thenAnswer((_) async => jsonResponse('dummy_data/popular_tv.json'));

    final result = await dataSource.getTvRecommendations(id);

    expect(result, expected);
  });

  test('searchTv jalan', () async {
    const query = 'Breaking Bad';
    final expected = PagedResponseDto<TvListDto>.fromJson(
      json.decode(readJson('dummy_data/search_tv.json')),
      TvListDto.fromJson,
      where: (item) => item.posterPath != null,
    ).results;

    when(mockHttpClient
            .get(Uri.parse('$baseUrl/search/tv?$apiKey&query=$query')))
        .thenAnswer((_) async => jsonResponse('dummy_data/search_tv.json'));

    final result = await dataSource.searchTv(query);

    expect(result, expected);
  });
}
