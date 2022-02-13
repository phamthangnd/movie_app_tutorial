import 'package:dartz/dartz.dart';
import 'package:movieapp/domain/entities/record_entity.dart';
import 'package:movieapp/domain/repositories/scan_repository.dart';

import '../entities/app_error.dart';
import 'usecase.dart';

class GetListRecord extends UseCase<List<RecordEntity>, DateTime> {
  final ScanRepository repository;

  GetListRecord(this.repository);

  @override
  Future<Either<AppError, List<RecordEntity>>> call(
      DateTime? dateTime) async {
    return await repository.getListRecords(dateTime: dateTime?? DateTime.now());
  }
}
