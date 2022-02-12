import 'package:dartz/dartz.dart';
import 'package:movieapp/domain/entities/account_entity.dart';

import '../entities/app_error.dart';

abstract class UserRepository {
  Future<Either<AppError, AccountEntity>> getAccountInfo();
}
