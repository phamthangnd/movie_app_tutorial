part of 'get_account_cubit.dart';

abstract class GetAccountState extends Equatable {
  const GetAccountState();

  @override
  List<Object> get props => [];
}

class GetAccountInitial extends GetAccountState {}

class GetAccountLoading extends GetAccountState {}

class GetAccountError extends GetAccountState {
  final AppErrorType errorType;

  const GetAccountError(this.errorType);
}

class GetAccountLoaded extends GetAccountState {
  final AccountEntity accountInfo;

  const GetAccountLoaded({
    required this.accountInfo,
  });

  @override
  List<Object> get props => [accountInfo];
}
