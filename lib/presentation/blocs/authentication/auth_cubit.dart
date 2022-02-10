import 'package:bloc/bloc.dart';
import 'package:movieapp/domain/entities/no_params.dart';
import 'package:movieapp/domain/usecases/check_auth.dart';
import 'package:movieapp/presentation/blocs/loading/loading_cubit.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.dart';
part 'auth_cubit.freezed.dart';

class AuthCubit extends Cubit<AuthState> {
  final CheckAuthUseCase checkAuth;
  final LoadingCubit loadingCubit;

  AuthCubit({
    required this.checkAuth,
    required this.loadingCubit,
  }) : super(AuthState.initial(isSignedIn: false)) {
    checkAuth(NoParams()).then((eitherResponse) {
      emit(eitherResponse.fold(
        (l) {
          return state.copyWith(isSignedIn: false);
        },
        (r) => state.copyWith(isSignedIn: r),
      ));
    });
  }
}
