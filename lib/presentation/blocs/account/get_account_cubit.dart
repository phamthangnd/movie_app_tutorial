import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movieapp/domain/entities/account_entity.dart';
import 'package:movieapp/domain/entities/app_error.dart';
import 'package:movieapp/domain/entities/no_params.dart';
import 'package:movieapp/domain/usecases/get_account_info.dart';
import 'package:movieapp/presentation/blocs/loading/loading_cubit.dart';

part 'get_account_state.dart';

class GetAccountCubit extends Cubit<GetAccountState> {
  final GetAccountInfo getAccountInfo;
  final LoadingCubit loadingCubit;

  GetAccountCubit({
    required this.getAccountInfo,
    required this.loadingCubit,
  }) : super(GetAccountInitial());

  void loadAccountInfo() async {
    loadingCubit.show();
    final moviesEither = await getAccountInfo(NoParams());
    emit(moviesEither.fold(
          (l) => GetAccountError(l.appErrorType),
          (account) {
        return GetAccountLoaded(
          accountInfo: account,
        );
      },
    ));
    loadingCubit.hide();
  }
}
