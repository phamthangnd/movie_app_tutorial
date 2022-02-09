import 'package:movieapp/data/models/record_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'records_database.dart';

class RecordsDatabaseImpl implements RecordsDatabase {
  static const _databaseName = 'cccd_database';
  static const _tableName = 'record_table';
  static const _databaseVersion = 1;
  static const _columnId = 'id';
  static const _columnCCCD = 'so_cccd';
  static const _columnCMND = 'so_cmnd';
  static const _columnDiachi = 'dia_chi';
  static const _columnNgayCap = 'ngay_cap';
  static const _columnHoTen = 'ho_ten';
  static const _columnNamSinh = 'nam_sinh';
  static const _columnGioiTinh = 'gioi_tinh';
  static Database? _database;

  Future<Database> get database async {
    if (_database == null) _database = await _initDatabase();
    return _database!;
   }
  Future<Database> _initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), _databaseName),
      onCreate: (db, _) {
        db.execute('''
          CREATE TABLE $_tableName(
            $_columnId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            $_columnCCCD TEXT NOT NULL,
            $_columnCMND TEXT,
            $_columnDiachi INTEGER NOT NULL,
            $_columnNgayCap TEXT NOT NULL,
            $_columnHoTen  TEXT NOT NULL,
            $_columnNamSinh  TEXT NOT NULL,
            $_columnGioiTinh  TEXT NOT NULL,
          )
        ''');
      },
      version: _databaseVersion,
    );
  }

  @override
  Future<List<RecordModel>> allRecords() async{
    final db = await database;
    return db.query(_tableName).then((value) => value.map((e) => RecordModel.fromJson(e)).toList());
  }

  @override
  Future<void> deleteTodo(int id) async {
    final db = await database;
    await db.delete(
      _tableName,
      where: '$_columnId = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<RecordModel> insertTodo(RecordModel record) async{
    final db = await database;
    late final RecordModel todoEntity;
    await db.transaction((txn) async {
      final id = await txn.insert(
        _tableName,
        record.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      final results = await txn.query(_tableName, where: '$_columnId = ?', whereArgs: [id]);
      todoEntity = RecordModel.fromJson(results.first);
    });
    return todoEntity;
  }

  @override
  Future<void> updateTodo(RecordModel record)async {
    final db = await database;
    final int? id = int.tryParse(record.soCccd!);
    await db.update(
      _tableName,
      record.toJson(),
      where: '$_columnId = ?',
      whereArgs: [id],
    );
  }
}