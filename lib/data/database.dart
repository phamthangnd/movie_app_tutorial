import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

const List<String> initScript = [
  '''
    CREATE TABLE notifications (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      description TEXT,
      read INTEGER NOT NULL,
      created_at INTEGER NOT NULL,
      transaction_id TEXT NULL,
      user_id INTEGER DEFAULT 0,
      notification_type TEXT NULL
  )''',
  '''
    CREATE TABLE device_user (
      user_id INTEGER PRIMARY KEY,
      is_first_time_on_device INTEGER DEFAULT 0,
      is_mute_notification INTEGER DEFAULT 0
  )''',
];

// Run on old app, DO NOT EDIT, ONLY APPEND
const List<String> migrationScripts = [
  // 'ALTER TABLE notifications ADD COLUMN transaction_id TEXT NULL', // V2
  // 'ALTER TABLE notifications ADD COLUMN user_id INTEGER DEFAULT 0', // V3
  // '''
  //   CREATE TABLE device_user (
  //     user_id INTEGER PRIMARY KEY,
  //     is_first_time_on_device INTEGER DEFAULT 0
  // )''', // V4
  // 'ALTER TABLE notifications ADD COLUMN notification_type TEXT NULL', // V5
  // 'ALTER TABLE device_user ADD COLUMN is_mute_notification INTEGER DEFAULT 0', // V6
];

class DBHelper {

  Database? _db;

  Future<Database> db() async {
    if (_db == null) await init();
    return _db!;
  }

  Future onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future init() async {
    var databasesPath = await getDatabasesPath();
    String dbPath = path.join(databasesPath, "platformValues.db");
    _db = await openDatabase(
      dbPath,
      version: migrationScripts.length + 1,
      onConfigure: onConfigure,
      onCreate: (Database db, int version) async {
        initScript.forEach((script) async => await db.execute(script));
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        for (var i = oldVersion; i < newVersion; i++) {
          await db.execute(migrationScripts[i - 1]);
        }
      },
    );
  }

//   static Future<Database> database() async {
//     final dbPath = await sql.getDatabasesPath();
//     return sql.openDatabase(path.join(dbPath, 'places.db'),
//         onCreate: (db, version) {
// initScript.forEach((script) async => await db.execute(script));
//         }, version: 1);
//   }
//
//   static Future<void> insert(String table, Map<String, Object> data) async {
//     final db = await DBHelper.database();
//     db.insert(
//       table,
//       data,
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }
//
//   static Future<List<Map<String, dynamic>>> getData(String table) async {
//     final db = await DBHelper.database();
//     return db.query(table);
//   }
}
