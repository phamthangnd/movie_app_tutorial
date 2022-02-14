part of 'exported_record_cubit.dart';

@immutable
abstract class ExportedRecordState {}

class ExportedRecordInitial extends ExportedRecordState {}
class ExportedRecordLoading extends ExportedRecordState {}
class ExportedRecordSuccess extends ExportedRecordState {}
class ExportedRecordError extends ExportedRecordState {
  final AppErrorType errorType;
  ExportedRecordError(this.errorType);
}
