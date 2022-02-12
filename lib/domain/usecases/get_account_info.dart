import 'package:dartz/dartz.dart';
import 'package:movieapp/domain/entities/account_entity.dart';
import 'package:movieapp/domain/entities/no_params.dart';
import 'package:movieapp/domain/repositories/user_repository.dart';

import '../entities/app_error.dart';
import 'usecase.dart';

class GetAccountInfo extends UseCase<AccountEntity, NoParams> {
  final UserRepository _userRepository;

  GetAccountInfo(this._userRepository);

  @override
  Future<Either<AppError, AccountEntity>> call(NoParams noParams) async =>
      _userRepository.getAccountInfo();
}
