import 'package:dartz/dartz.dart';
import 'package:movieapp/domain/entities/app_error.dart';

abstract class ScanRepository {
  // Future<Either<AppError, bool>> loginUser(Map<String, dynamic> params);
  // Future<Either<AppError, bool>> isLoggedInUser();
  Future<Either<AppError, void>> saveResultScan(String data);
}