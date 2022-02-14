import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:excel/excel.dart';
import 'package:path/path.dart' as path;
import 'package:movieapp/data/core/unathorised_exception.dart';
import 'package:movieapp/data/data_sources/authentication_local_data_source.dart';
import 'package:movieapp/data/database/records_database.dart';
import 'package:movieapp/data/models/record_model.dart';
import 'package:movieapp/domain/entities/app_error.dart';
import 'package:movieapp/domain/entities/record_entity.dart';
import 'package:movieapp/domain/mappers/record_mapper.dart';
import 'package:movieapp/domain/repositories/scan_repository.dart';
import 'package:path_provider/path_provider.dart';

class ScanRepositoryImpl extends ScanRepository {
  // final AuthenticationRemoteDataSource remoteDataSource;
  final AuthenticationLocalDataSource localDataSource;
  final RecordsDatabase localDatabase;
  final RecordMapper recordMapper;
  ScanRepositoryImpl(
    this.localDataSource,
    this.localDatabase,
    this.recordMapper,
  );

  @override
  Future<Either<AppError, RecordEntity>> saveResultScan(String data) async {
    if (data.isEmpty) return Left(AppError(AppErrorType.empty));
    List<String> listSplit = _split(data, '|');
    RecordModel recordModel = RecordModel(
      soCccd: listSplit.first,
      soCmnd: listSplit[1],
      hoTen: listSplit[2],
      namSinh: listSplit[3].substring(4, 8),
      gioiTinh: listSplit[4],
      diaChi: listSplit[5],
      ngayCap: listSplit.last,
    );
    var userId = await localDataSource.getLoggedIn().then((value) => value!.account!.id!);
    try {
      RecordModel res = await localDatabase.insertRecord(recordModel, userId);
      if (res != null && res.id != null) {
        return Right(recordMapper.to(res));
      }
      return Left(AppError(AppErrorType.database));
    } on SocketException {
      return Left(AppError(AppErrorType.network));
    } on UnauthorisedException {
      return Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return Left(AppError(AppErrorType.api));
    }
  }

  List<String> _split(String string, String separator, {int max = 0}) {
    var result = <String>[];
    if (separator.isEmpty) {
      result.add(string);
      return result;
    }
    while (true) {
      var index = string.indexOf(separator, 0);
      if (index == -1 || (max > 0 && result.length >= max)) {
        result.add(string);
        break;
      }
      result.add(string.substring(0, index));
      string = string.substring(index + separator.length);
    }
    return result;
  }

  @override
  Future<Either<AppError, List<RecordEntity>>> getListRecords({DateTime? dateTime}) async {
    var userId = await localDataSource.getLoggedIn().then((value) => value!.account!.id!);
    var list = <RecordEntity>[];
    try {
      List<RecordModel> res = await localDatabase.getListRecordByDate(dateTime, userId);
      if (res != null && res.length > 0) {
        for (var model in res) {
          list.add(recordMapper.to(model));
        }
        return Right(list);
      }
      return Right([]);
    } on UnauthorisedException {
      return Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return Left(AppError(AppErrorType.database));
    }
  }

  @override
  Future<Either<AppError, bool>> exportData(List<RecordEntity> list) async {
    Stopwatch stopwatch = new Stopwatch()..start();
    Excel excel = Excel.createExcel();
    Sheet sh = excel['Sheet1'];

    ///HEADER
    // var item = list[0]; // entity
    // var iCol = 0;
    // Map<String, dynamic> hmapEntity = item.toMap();
    // var hReversed = Map.fromEntries(hmapEntity.entries.map((e) => MapEntry(e.key, e.value)));
    // for (var kv in hReversed.entries) {
    //   sh.cell(CellIndex.indexByColumnRow(rowIndex: 0, columnIndex: iCol)).value = kv.key;
    //   iCol++;
    // }
    var rows = list.length;
    for (int row = 0; row < rows; row++) {
      var entity = list[row]; // entity
      Map<String, dynamic> mapEntity = entity.toMap();
      var reversed = Map.fromEntries(mapEntity.entries.map((e) => MapEntry(e.key, e.value)));
      var _col = 0;
      for (var kv in reversed.entries) {
        sh.cell(CellIndex.indexByColumnRow(rowIndex: row, columnIndex: _col)).value = kv.value;
        _col++;
      }
    }
    print('Generating executed in ${stopwatch.elapsed}');
    stopwatch.reset();
    var onValue = excel.encode();
    print('Encoding executed in ${stopwatch.elapsed}');
    stopwatch.reset();
    Directory? appDocDir = Platform.isAndroid
        ? await getExternalStorageDirectory() //FOR ANDROID
        : await getApplicationDocumentsDirectory(); //FOR iOS
    if (appDocDir == null) {
      // throw UnimplementedError('getApplicationSupportPath() has not been implemented.');
      return Left(AppError(AppErrorType.permissionDeny));
    }
    String appDocPath = appDocDir.path;
    String dbPath = path.join(appDocPath, "${DateTime.now().toIso8601String()}.xlsx");
    File(dbPath)
      ..createSync(recursive: true)
      ..writeAsBytesSync(onValue!);
    print('File exported at $dbPath');
    print('Exported file in ${stopwatch.elapsed}');
    return Right(true);
  }
}
