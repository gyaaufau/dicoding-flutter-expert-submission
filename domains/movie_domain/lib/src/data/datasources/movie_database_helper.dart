import 'dart:async';

import 'package:dependencies/dependencies.dart';

import '../models/movie_table.dart';

class MovieDatabaseHelper {
  static MovieDatabaseHelper? _databaseHelper;

  MovieDatabaseHelper._instance() {
    _databaseHelper = this;
  }

  factory MovieDatabaseHelper() =>
      _databaseHelper ?? MovieDatabaseHelper._instance();

  static Database? _database;

  Future<Database?> get database async {
    _database ??= await _initDb();
    return _database;
  }

  static const String _tblWatchlist = 'watchlist';
  static const String _tblWatchlistTv = 'watchlist_tv';
  static const String _tblCache = 'cache';

  Future<Database> _initDb() async {
    final path = await getDatabasesPath();
    final databasePath = '$path/ditonton.db';

    return openDatabase(
      databasePath,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tblWatchlist (
        id INTEGER PRIMARY KEY,
        title TEXT,
        overview TEXT,
        posterPath TEXT
      );
    ''');
    await db.execute('''
      CREATE TABLE $_tblWatchlistTv (
        id INTEGER PRIMARY KEY,
        title TEXT,
        overview TEXT,
        posterPath TEXT
      );
    ''');
    await db.execute('''
      CREATE TABLE $_tblCache (
        id INTEGER PRIMARY KEY,
        title TEXT,
        overview TEXT,
        posterPath TEXT,
        category TEXT
      );
    ''');
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE $_tblWatchlistTv (
          id INTEGER PRIMARY KEY,
          title TEXT,
          overview TEXT,
          posterPath TEXT
        );
      ''');
    }
  }

  Future<int> insertWatchlist(MovieTable movie) async {
    final db = await database;
    return db!.insert(_tblWatchlist, movie.toJson());
  }

  Future<int> removeWatchlist(MovieTable movie) async {
    final db = await database;
    return db!.delete(_tblWatchlist, where: 'id = ?', whereArgs: [movie.id]);
  }

  Future<Map<String, dynamic>?> getMovieById(int id) async {
    final db = await database;
    final results = await db!.query(
      _tblWatchlist,
      where: 'id = ?',
      whereArgs: [id],
    );

    return results.isNotEmpty ? results.first : null;
  }

  Future<List<Map<String, dynamic>>> getWatchlistMovies() async {
    final db = await database;
    return db!.query(_tblWatchlist);
  }

  Future<void> insertCacheTransaction(
    List<MovieTable> movies,
    String category,
  ) async {
    final db = await database;
    await db!.transaction((txn) async {
      for (final movie in movies) {
        final movieJson = movie.toJson();
        movieJson['category'] = category;
        await txn.insert(_tblCache, movieJson);
      }
    });
  }

  Future<List<Map<String, dynamic>>> getCacheMovies(String category) async {
    final db = await database;
    return db!.query(_tblCache, where: 'category = ?', whereArgs: [category]);
  }

  Future<int> clearCache(String category) async {
    final db = await database;
    return db!.delete(_tblCache, where: 'category = ?', whereArgs: [category]);
  }
}
