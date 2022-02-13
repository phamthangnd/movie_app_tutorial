import 'package:dartz/dartz.dart';
import 'package:movieapp/domain/entities/app_error.dart';
import 'package:movieapp/domain/entities/record_entity.dart';

abstract class ScanRepository {
  // Future<Either<AppError, bool>> loginUser(Map<String, dynamic> params);
  // Future<Either<AppError, bool>> isLoggedInUser();
  Future<Either<AppError, RecordEntity>> saveResultScan(String data);
}