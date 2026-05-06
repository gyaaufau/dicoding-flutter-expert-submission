import 'package:common/common.dart';
import 'package:movie_domain/movie_domain.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../dummy_data/dummy_objects.dart';

class FakeMovieDatabaseHelper implements MovieDatabaseHelper {
  Future<int> Function(MovieTable movie)? onInsertWatchlist;
  Future<int> Function(MovieTable movie)? onRemoveWatchlist;
  Future<Map<String, dynamic>?> Function(int id)? onGetMovieById;
  Future<List<Map<String, dynamic>>> Function()? onGetWatchlistMovies;

  @override
  Future<int> insertWatchlist(MovieTable movie) => onInsertWatchlist!(movie);

  @override
  Future<int> removeWatchlist(MovieTable movie) => onRemoveWatchlist!(movie);

  @override
  Future<Map<String, dynamic>?> getMovieById(int id) => onGetMovieById!(id);

  @override
  Future<List<Map<String, dynamic>>> getWatchlistMovies() =>
      onGetWatchlistMovies!();

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late MovieLocalDataSourceImpl dataSource;
  late FakeMovieDatabaseHelper fakeDatabaseHelper;

  setUp(() {
    fakeDatabaseHelper = FakeMovieDatabaseHelper();
    dataSource = MovieLocalDataSourceImpl(databaseHelper: fakeDatabaseHelper);
  });

  group('save watchlist', () {
    test('should return success message when insert to database is success',
        () async {
      // arrange
      fakeDatabaseHelper.onInsertWatchlist = (_) async => 1;
      // act
      final result = await dataSource.insertWatchlist(testMovieTable);
      // assert
      expect(result, 'Added to Watchlist');
    });

    test('should throw DatabaseException when insert to database is failed',
        () async {
      // arrange
      fakeDatabaseHelper.onInsertWatchlist = (_) => throw Exception();
      // act
      final call = dataSource.insertWatchlist(testMovieTable);
      // assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('remove watchlist', () {
    test('should return success message when remove from database is success',
        () async {
      // arrange
      fakeDatabaseHelper.onRemoveWatchlist = (_) async => 1;
      // act
      final result = await dataSource.removeWatchlist(testMovieTable);
      // assert
      expect(result, 'Removed from Watchlist');
    });

    test('should throw DatabaseException when remove from database is failed',
        () async {
      // arrange
      fakeDatabaseHelper.onRemoveWatchlist = (_) => throw Exception();
      // act
      final call = dataSource.removeWatchlist(testMovieTable);
      // assert
      expect(() => call, throwsA(isA<DatabaseException>()));
    });
  });

  group('Get Movie Detail By Id', () {
    final tId = 1;

    test('should return Movie Detail Table when data is found', () async {
      // arrange
      fakeDatabaseHelper.onGetMovieById = (_) async => testMovieMap;
      // act
      final result = await dataSource.getMovieById(tId);
      // assert
      expect(result, testMovieTable);
    });

    test('should return null when data is not found', () async {
      // arrange
      fakeDatabaseHelper.onGetMovieById = (_) async => null;
      // act
      final result = await dataSource.getMovieById(tId);
      // assert
      expect(result, null);
    });
  });

  group('get watchlist movies', () {
    test('should return list of MovieTable from database', () async {
      // arrange
      fakeDatabaseHelper.onGetWatchlistMovies = () async => [testMovieMap];
      // act
      final result = await dataSource.getWatchlistMovies();
      // assert
      expect(result, [testMovieTable]);
    });
  });
}
