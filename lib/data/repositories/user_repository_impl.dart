import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:movieapp/data/core/unathorised_exception.dart';
import 'package:movieapp/data/data_sources/authentication_local_data_source.dart';
import 'package:movieapp/data/data_sources/authentication_remote_data_source.dart';
import 'package:movieapp/domain/entities/account_entity.dart';
import 'package:movieapp/domain/entities/app_error.dart';
import 'package:movieapp/domain/repositories/user_repository.dart';

class UserRepositoryImpl extends UserRepository {
  final AuthenticationRemoteDataSource remoteDataSource;
  final AuthenticationLocalDataSource localDataSource;

  UserRepositoryImpl(
    this.remoteDataSource,
    this.localDataSource,
  );

  @override
  Future<Either<AppError, AccountEntity>> getAccountInfo() async {
    try {
      var res = await localDataSource.getLoggedIn();
      if (res != null && res.account != null) {
        var account = AccountEntity.fromJson(res.account!.toJson());
        return Right(account);
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
}
