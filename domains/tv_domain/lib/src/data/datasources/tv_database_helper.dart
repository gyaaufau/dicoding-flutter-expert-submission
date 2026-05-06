import 'dart:async';

import 'package:dependencies/dependencies.dart';

import '../models/tv_table.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;

  DatabaseHelper._instance() {
    _databaseHelper = this;
  }

  factory DatabaseHelper() => _databaseHelper ?? DatabaseHelper._instance();

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

  Future<int> insertTvWatchlist(TvTable tv) async {
    final db = await database;
    return db!.insert(_tblWatchlistTv, tv.toJson());
  }

  Future<int> removeTvWatchlist(TvTable tv) async {
    final db = await database;
    return db!.delete(_tblWatchlistTv, where: 'id = ?', whereArgs: [tv.id]);
  }

  Future<Map<String, dynamic>?> getTvById(int id) async {
    final db = await database;
    final results = await db!.query(
      _tblWatchlistTv,
      where: 'id = ?',
      whereArgs: [id],
    );

    return results.isNotEmpty ? results.first : null;
  }

  Future<List<Map<String, dynamic>>> getWatchlistTv() async {
    final db = await database;
    return db!.query(_tblWatchlistTv);
  }
}
