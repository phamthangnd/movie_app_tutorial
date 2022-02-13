import 'package:movieapp/data/models/record_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'records_database.dart';

class RecordsDatabaseImpl implements RecordsDatabase {
  static const _databaseName = 'cccd_1402.db';
  static const _tableName = 'record_table';
  static const _databaseVersion = 1;
  static const _columnId = 'id';
  static const _columnUserId = 'user_id';
  static const _columnCCCD = 'so_cccd';
  static const _columnCMND = 'so_cmnd';
  static const _columnDiachi = 'dia_chi';
  static const _columnNgayCap = 'ngay_cap';
  static const _columnHoTen = 'ho_ten';
  static const _columnNamSinh = 'nam_sinh';
  static const _columnGioiTinh = 'gioi_tinh';
  static const _columnCreatedAt = 'created_at';
  static const _columnUpdatedAt = 'updated_at';
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
            $_columnDiachi TEXT NOT NULL,
            $_columnNgayCap TEXT NOT NULL,
            $_columnHoTen  TEXT NOT NULL,
            $_columnNamSinh  TEXT NOT NULL,
            $_columnGioiTinh  TEXT NOT NULL,
            $_columnUserId  INTEGER,
            $_columnCreatedAt  TEXT NOT NULL,
            $_columnUpdatedAt  TEXT NOT NULL
          )
        ''');
      },
      version: _databaseVersion,
    );
  }

  @override
  Future<List<RecordModel>> allRecords(int userId) async {
    final db = await database;
    List<Map<String, dynamic>> maps =
        await db.rawQuery('SELECT * FROM $_tableName WHERE $_columnUserId = ? ORDER BY created_at DESC', // LIMIT ? OFFSET ?',
            [
          userId,
        ]); // limit, offset]);
    if (maps.length <= 0) {
      return [];
    }
    List<RecordModel> list = [];
    maps.forEach((e) {
      print('e in Repo: $e');
      list.add(RecordModel.fromJson(e));
    });
    return list;
    //return db.query(_tableName).then((value) => value.map((e) => RecordModel.fromJson(e)).toList());
  }

  @override
  Future<List<RecordModel>> getListRecordByDate(DateTime? dateTime, int userId) async {
    final db = await database;
    var sevenDateMillis = (dateTime ?? DateTime.now()).millisecondsSinceEpoch; // - 7 * 24 * 3600 * 1000;
    var sevenDate = DateTime.fromMillisecondsSinceEpoch(sevenDateMillis);
    var sevenDateReset = DateTime(sevenDate.year, sevenDate.month, sevenDate.day);
    List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM $_tableName WHERE $_columnUserId = ? AND $_columnCreatedAt = ? ORDER BY $_columnCreatedAt DESC', // LIMIT ? OFFSET ?',
        [userId, sevenDateReset.toIso8601String()]); // limit, offset]);
    if (maps.length <= 0) {
      return [];
    }
    List<RecordModel> list = <RecordModel>[];
    maps.forEach((e) {
      print('e in Repo: $e');
      list.add(RecordModel.fromJson(e));
    });
    print('list Record by dateTime from DB: ${list.length}');
    return list;
  }

  @override
  Future<void> deleteRecord(int id) async {
    final db = await database;
    await db.delete(
      _tableName,
      where: '$_columnId = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<RecordModel> insertRecord(RecordModel record, int userId) async {
    var currentDateMillis = DateTime.now().millisecondsSinceEpoch;
    var nowDate = DateTime.fromMillisecondsSinceEpoch(currentDateMillis);
    var nowReset = DateTime(nowDate.year, nowDate.month, nowDate.day);
    Map<String, dynamic> details = {
      _columnUserId: userId,
      _columnCCCD: record.soCccd,
      _columnCMND: record.soCmnd,
      _columnDiachi: record.diaChi,
      _columnNgayCap: record.ngayCap,
      _columnHoTen: record.hoTen,
      _columnNamSinh: record.namSinh,
      _columnGioiTinh: record.gioiTinh,
      _columnCreatedAt: nowReset.toIso8601String(),
      _columnUpdatedAt: nowReset.toIso8601String(),
    };
    final db = await database;
    late final RecordModel recordModel;
    final id = await db.insert(
      _tableName,
      details,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    final results = await db.query(_tableName, where: '$_columnId = ?', whereArgs: [id]);
    recordModel = RecordModel.fromJson(results.first);
    return recordModel;
  }

  @override
  Future<void> updateRecord(RecordModel record) async {
    var currentDateMillis = DateTime.now().millisecondsSinceEpoch;
    var nowDate = DateTime.fromMillisecondsSinceEpoch(currentDateMillis);
    var nowReset = DateTime(nowDate.year, nowDate.month, nowDate.day);
    Map<String, dynamic> details = {
      _columnCCCD: record.soCccd,
      _columnCMND: record.soCmnd,
      _columnDiachi: record.diaChi,
      _columnNgayCap: record.ngayCap,
      _columnHoTen: record.hoTen,
      _columnNamSinh: record.namSinh,
      _columnGioiTinh: record.gioiTinh,
      _columnUpdatedAt: nowReset.toIso8601String(),
    };
    final db = await database;
    await db.update(
      _tableName,
      details,
      where: '$_columnId = ?',
      whereArgs: [record.id ?? 0],
    );
  }
}
