part of 'get_record_cubit.dart';

@immutable
abstract class GetRecordState {}

class GetRecordInitial extends GetRecordState {}
class GetRecordLoading extends GetRecordState {}
class GetRecordSuccess extends GetRecordState {
  final List<RecordEntity> records;

  GetRecordSuccess(this.records);
}
class GetRecordError extends GetRecordState {
  final AppErrorType errorType;

  GetRecordError(this.errorType);
}
