import 'dart:convert';

import 'package:common/common.dart';
import 'package:core/core.dart';
import 'package:tv_domain/src/data/models/tv_detail_dto.dart';
import 'package:tv_domain/src/data/models/tv_list_dto.dart';
import 'package:tv_domain/src/data/models/tv_season_detail_dto.dart';
import 'package:dependencies/dependencies.dart' as dep;

abstract class TvRemoteDataSource {
  Future<List<TvListDto>> getOnTheAirTv();
  Future<List<TvListDto>> getPopularTv();
  Future<List<TvListDto>> getTopRatedTv();
  Future<TvDetailDto> getTvDetail(int id);
  Future<TvSeasonDetailDto> getTvSeasonDetail(int seriesId, int seasonNumber);
  Future<List<TvListDto>> getTvRecommendations(int id);
  Future<List<TvListDto>> searchTv(String query);
}

class TvRemoteDataSourceImpl implements TvRemoteDataSource {
  static const apiKey = 'api_key=854d566c17a9fda8ae51ddfbda4fd5d8';
  static const baseUrl = 'https://api.themoviedb.org/3';

  final dep.Client client;

  TvRemoteDataSourceImpl({required this.client});

  @override
  Future<List<TvListDto>> getOnTheAirTv() async =>
      _getTvListFromUrl('$baseUrl/tv/on_the_air?$apiKey');

  @override
  Future<List<TvListDto>> getPopularTv() async =>
      _getTvListFromUrl('$baseUrl/tv/popular?$apiKey');

  @override
  Future<List<TvListDto>> getTopRatedTv() async =>
      _getTvListFromUrl('$baseUrl/tv/top_rated?$apiKey');

  @override
  Future<TvDetailDto> getTvDetail(int id) async {
    final response = await client.get(Uri.parse('$baseUrl/tv/$id?$apiKey'));
    return _handleResponse(
      response,
      (body) => TvDetailDto.fromJson(json.decode(body)),
    );
  }

  @override
  Future<List<TvListDto>> getTvRecommendations(int id) async =>
      _getTvListFromUrl('$baseUrl/tv/$id/recommendations?$apiKey');

  @override
  Future<TvSeasonDetailDto> getTvSeasonDetail(
    int seriesId,
    int seasonNumber,
  ) async {
    final response = await client.get(
      Uri.parse('$baseUrl/tv/$seriesId/season/$seasonNumber?$apiKey'),
    );
    return _handleResponse(
      response,
      (body) => TvSeasonDetailDto.fromJson(json.decode(body)),
    );
  }

  @override
  Future<List<TvListDto>> searchTv(String query) async =>
      _getTvListFromUrl('$baseUrl/search/tv?$apiKey&query=$query');

  Future<List<TvListDto>> _getTvListFromUrl(String url) async {
    final response = await client.get(Uri.parse(url));
    return _handleResponse(
      response,
      (body) => PagedResponseDto<TvListDto>.fromJson(
        json.decode(body),
        TvListDto.fromJson,
        where: (item) => item.posterPath != null,
      ).results,
    );
  }

  T _handleResponse<T>(
    dep.Response response,
    T Function(String body) onSuccess,
  ) {
    try {
      if (response.statusCode != 200) {
        throw ServerException();
      }

      return onSuccess(response.body);
    } on ServerException {
      rethrow;
    } catch (_) {
      throw ServerException();
    }
  }
}
