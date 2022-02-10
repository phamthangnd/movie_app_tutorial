import 'package:dartz/dartz.dart';
import 'package:movieapp/domain/entities/app_error.dart';
import 'package:movieapp/domain/entities/no_params.dart';
import 'package:movieapp/domain/repositories/authentication_repository.dart';
import 'package:movieapp/domain/usecases/usecase.dart';

class CheckAuthUseCase extends UseCase<bool, NoParams> {
  final AuthenticationRepository authenticationRepository;

  CheckAuthUseCase(this.authenticationRepository);

  @override
  Future<Either<AppError, bool>> call(NoParams noParams) async {
    return await authenticationRepository.isLoggedInUser();
  }
}