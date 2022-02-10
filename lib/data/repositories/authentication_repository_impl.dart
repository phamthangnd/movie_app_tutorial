import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../domain/entities/app_error.dart';
import '../../domain/repositories/authentication_repository.dart';
import '../core/unathorised_exception.dart';
import '../data_sources/authentication_local_data_source.dart';
import '../data_sources/authentication_remote_data_source.dart';

class AuthenticationRepositoryImpl extends AuthenticationRepository {
  final AuthenticationRemoteDataSource _authenticationRemoteDataSource;
  final AuthenticationLocalDataSource _authenticationLocalDataSource;

  AuthenticationRepositoryImpl(
    this._authenticationRemoteDataSource,
    this._authenticationLocalDataSource,
  );

  @override
  Future<Either<AppError, bool>> loginUser(Map<String, dynamic> body) async {
    try {
      final loginResponseWithToken = await _authenticationRemoteDataSource.login(body);
      final sessionId = loginResponseWithToken.token;
      if (sessionId != null) {
        await _authenticationLocalDataSource.saveToken(sessionId);
        await _authenticationLocalDataSource.saveLoggedIn(loginResponseWithToken);
        return Right(true);
      }
      return Left(AppError(AppErrorType.sessionDenied));
    } on SocketException {
      return Left(AppError(AppErrorType.network));
    } on UnauthorisedException {
      return Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return Left(AppError(AppErrorType.api));
    }
  }

  @override
  Future<Either<AppError, void>> logoutUser() async {
    final sessionId = await _authenticationLocalDataSource.getToken();
    if (sessionId != null) {
      await Future.wait([
        // _authenticationRemoteDataSource.deleteSession(sessionId),
        _authenticationLocalDataSource.deleteSessionId(),
        _authenticationLocalDataSource.deleteLoggedInData(),
      ]);
    }
    print(await _authenticationLocalDataSource.getToken());
    return Right(Unit);
  }

  @override
  Future<Either<AppError, bool>> isLoggedInUser() async {
    try {
      var res = await _authenticationLocalDataSource.isLoggedIn();
      if (res) {
        return Right(true);
      }
      return Right(false);
    } on SocketException {
      return Left(AppError(AppErrorType.network));
    } on UnauthorisedException {
      return Left(AppError(AppErrorType.unauthorised));
    } on Exception {
      return Left(AppError(AppErrorType.api));
    }
  }
}
