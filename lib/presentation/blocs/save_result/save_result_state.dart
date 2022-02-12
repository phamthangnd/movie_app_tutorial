part of 'save_result_cubit.dart';

@immutable
abstract class SaveResultState {}

class SaveResultInitial extends SaveResultState {}
class SaveResultLoading extends SaveResultState {}
class SaveResultSuccess extends SaveResultState {}
class SaveResultError extends SaveResultState {
  final AppErrorType errorType;

  SaveResultError(this.errorType);
}
