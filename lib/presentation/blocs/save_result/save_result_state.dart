part of 'save_result_cubit.dart';

@immutable
abstract class SaveResultState {}

class SaveResultInitial extends SaveResultState {}
class SaveResultLoading extends SaveResultState {}
class SaveResultSuccess extends SaveResultState {
  final RecordEntity record;

  SaveResultSuccess(this.record);
}
class SaveResultError extends SaveResultState {
  final AppErrorType errorType;

  SaveResultError(this.errorType);
}

class AppCreateDatabaseState extends SaveResultState {}

class AppGetDatabaseLoadingState extends SaveResultState {}

class AppGetDatabaseState extends SaveResultState {}

class AppInsertDatabaseState extends SaveResultState {}

class AppUpdateDatabaseState extends SaveResultState {}

class AppDeleteDatabaseState extends SaveResultState {}

class AppChangeBottomSheetState extends SaveResultState {}
