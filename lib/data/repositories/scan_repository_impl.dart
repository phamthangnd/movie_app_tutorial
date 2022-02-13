import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:movieapp/data/core/unathorised_exception.dart';
import 'package:movieapp/data/data_sources/authentication_local_data_source.dart';
import 'package:movieapp/data/database/records_database.dart';
import 'package:movieapp/data/models/record_model.dart';
import 'package:movieapp/domain/entities/app_error.dart';
import 'package:movieapp/domain/entities/record_entity.dart';
import 'package:movieapp/domain/mappers/record_mapper.dart';
import 'package:movieapp/domain/repositories/scan_repository.dart';

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
    if(data.isEmpty) return Left(AppError(AppErrorType.empty));
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
}
