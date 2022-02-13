import 'package:dartz/dartz.dart';
import 'package:movieapp/domain/entities/app_error.dart';
import 'package:movieapp/domain/entities/record_entity.dart';

abstract class ScanRepository {
  Future<Either<AppError, RecordEntity>> saveResultScan(String data);
  Future<Either<AppError, List<RecordEntity>>> getListRecords({DateTime? dateTime});
}