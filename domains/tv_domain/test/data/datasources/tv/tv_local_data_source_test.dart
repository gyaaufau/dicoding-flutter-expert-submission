import 'package:common/common.dart';
import 'package:tv_domain/tv_domain.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeTvDatabaseHelper implements DatabaseHelper {
  Future<int> Function(TvTable tv)? onInsertTvWatchlist;
  Future<int> Function(TvTable tv)? onRemoveTvWatchlist;
  Future<Map<String, dynamic>?> Function(int id)? onGetTvById;
  Future<List<Map<String, dynamic>>> Function()? onGetWatchlistTv;

  @override
  Future<int> insertTvWatchlist(TvTable tv) => onInsertTvWatchlist!(tv);

  @override
  Future<int> removeTvWatchlist(TvTable tv) => onRemoveTvWatchlist!(tv);

  @override
  Future<Map<String, dynamic>?> getTvById(int id) => onGetTvById!(id);

  @override
  Future<List<Map<String, dynamic>>> getWatchlistTv() => onGetWatchlistTv!();

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late TvLocalDataSourceImpl dataSource;
  late FakeTvDatabaseHelper fakeDatabaseHelper;

  const tvTable = TvTable(
    id: 1,
    name: 'Breaking Bad',
    posterPath: '/poster.jpg',
    overview: 'overview',
  );

  final tvMap = {
    'id': 1,
    'name': 'Breaking Bad',
    'posterPath': '/poster.jpg',
    'overview': 'overview',
  };

  setUp(() {
    fakeDatabaseHelper = FakeTvDatabaseHelper();
    dataSource = TvLocalDataSourceImpl(databaseHelper: fakeDatabaseHelper);
  });

  test('insert watchlist tv berhasil', () async {
    fakeDatabaseHelper.onInsertTvWatchlist = (_) async => 1;

    final result = await dataSource.insertWatchlist(tvTable);

    expect(result, 'Added to Watchlist');
  });

  test('insert watchlist tv gagal lempar error', () async {
    fakeDatabaseHelper.onInsertTvWatchlist = (_) => throw Exception();

    final call = dataSource.insertWatchlist(tvTable);

    expect(() => call, throwsA(isA<DatabaseException>()));
  });

  test('remove watchlist tv berhasil', () async {
    fakeDatabaseHelper.onRemoveTvWatchlist = (_) async => 1;

    final result = await dataSource.removeWatchlist(tvTable);

    expect(result, 'Removed from Watchlist');
  });

  test('get tv by id ada datanya', () async {
    fakeDatabaseHelper.onGetTvById = (_) async => tvMap;

    final result = await dataSource.getTvById(1);

    expect(result, tvTable);
  });

  test('get watchlist tv isi list', () async {
    fakeDatabaseHelper.onGetWatchlistTv = () async => [tvMap];

    final result = await dataSource.getWatchlistTv();

    expect(result, [tvTable]);
  });
}
