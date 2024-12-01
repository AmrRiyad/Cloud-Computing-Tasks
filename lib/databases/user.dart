import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class UserDatabaseProvider {
  static final UserDatabaseProvider _instance =
      UserDatabaseProvider._internal();

  factory UserDatabaseProvider() => _instance;

  UserDatabaseProvider._internal();

  static Database? _db;

  Future<Database> get database async {
    try {
      _db ??= await _initDB();
    } catch (e) {
      rethrow;
    }

    return _db!;
  }

  Future<Database> _initDB() async {
    try {
      String path = join(await getDatabasesPath(), 'user.db');
      deleteDatabase(path);
      return await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate,
        onOpen: (db) {
          if (kDebugMode) {
            print("Database opened at $path");
          }
        },
        onDowngrade: onDatabaseDowngradeDelete,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await _createSubscriptionTable(db);
  }

  Future<void> _createSubscriptionTable(Database db) async {
    try {
      await db.execute('''
      CREATE TABLE channel(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        channelID TEXT, 
        userID TEXT
      )
    ''');
    } catch (e) {
      rethrow;
    }
  }


  Future<void> updateGuestUserIDToCurrentUser(String currentUserID) async {
    final db = await database;

    // Update the userID in the channel table
    await db.update(
      'channel',
      {'userID': currentUserID},
      where: 'userID = ?',
      whereArgs: ['GUEST'],
    );
  }

  Future<void> deleteUserData(String userID) async {
    final db = await database;

    // Delete rows from channel table
    await db.delete(
      'channel',
      where: 'userID = ?',
      whereArgs: [userID],
    );
  }
}
