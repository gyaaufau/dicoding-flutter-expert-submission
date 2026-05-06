import 'package:core/core.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:movie_domain/movie_domain.dart';
import 'package:tv_domain/tv_domain.dart';

@GenerateMocks([
  MovieRepository,
  TvRepository,
  MovieRemoteDataSource,
  MovieLocalDataSource,
  TvRemoteDataSource,
  TvLocalDataSource,
  MovieDatabaseHelper,
  NetworkInfo,
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient)
])
void main() {}
