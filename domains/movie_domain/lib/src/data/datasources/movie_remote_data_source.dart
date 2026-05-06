import 'dart:convert';

import 'package:common/common.dart';
import 'package:dependencies/dependencies.dart' as dep;

import '../models/movie_detail_model.dart';
import '../models/movie_model.dart';
import '../models/movie_response.dart';

abstract class MovieRemoteDataSource {
  Future<List<MovieModel>> getNowPlayingMovies();
  Future<List<MovieModel>> getPopularMovies();
  Future<List<MovieModel>> getTopRatedMovies();
  Future<MovieDetailResponse> getMovieDetail(int id);
  Future<List<MovieModel>> getMovieRecommendations(int id);
  Future<List<MovieModel>> searchMovies(String query);
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  static const apiKey = 'api_key=854d566c17a9fda8ae51ddfbda4fd5d8';
  static const baseUrl = 'https://api.themoviedb.org/3';

  MovieRemoteDataSourceImpl({required this.client});

  final dep.Client client;

  @override
  Future<List<MovieModel>> getNowPlayingMovies() async {
    final response = await client.get(
      Uri.parse('$baseUrl/movie/now_playing?$apiKey'),
    );

    if (response.statusCode == 200) {
      return MovieResponse.fromJson(json.decode(response.body)).movieList;
    }
    throw ServerException();
  }

  @override
  Future<MovieDetailResponse> getMovieDetail(int id) async {
    final response = await client.get(Uri.parse('$baseUrl/movie/$id?$apiKey'));

    if (response.statusCode == 200) {
      return MovieDetailResponse.fromJson(json.decode(response.body));
    }
    throw ServerException();
  }

  @override
  Future<List<MovieModel>> getMovieRecommendations(int id) async {
    final response = await client.get(
      Uri.parse('$baseUrl/movie/$id/recommendations?$apiKey'),
    );

    if (response.statusCode == 200) {
      return MovieResponse.fromJson(json.decode(response.body)).movieList;
    }
    throw ServerException();
  }

  @override
  Future<List<MovieModel>> getPopularMovies() async {
    final response = await client.get(
      Uri.parse('$baseUrl/movie/popular?$apiKey'),
    );

    if (response.statusCode == 200) {
      return MovieResponse.fromJson(json.decode(response.body)).movieList;
    }
    throw ServerException();
  }

  @override
  Future<List<MovieModel>> getTopRatedMovies() async {
    final response = await client.get(
      Uri.parse('$baseUrl/movie/top_rated?$apiKey'),
    );

    if (response.statusCode == 200) {
      return MovieResponse.fromJson(json.decode(response.body)).movieList;
    }
    throw ServerException();
  }

  @override
  Future<List<MovieModel>> searchMovies(String query) async {
    final response = await client.get(
      Uri.parse('$baseUrl/search/movie?$apiKey&query=$query'),
    );

    if (response.statusCode == 200) {
      return MovieResponse.fromJson(json.decode(response.body)).movieList;
    }
    throw ServerException();
  }
}
