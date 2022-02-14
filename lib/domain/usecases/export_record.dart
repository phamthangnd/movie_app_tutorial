import 'package:dartz/dartz.dart';
import 'package:movieapp/domain/entities/record_entity.dart';
import 'package:movieapp/domain/entities/save_result_params.dart';
import 'package:movieapp/domain/repositories/scan_repository.dart';

import '../entities/app_error.dart';
import 'usecase.dart';

class ExportedRecord extends UseCase<bool, List<RecordEntity>> {
  final ScanRepository scanRepository;

  ExportedRecord(this.scanRepository);

  @override
  Future<Either<AppError, bool>> call(List<RecordEntity> params) async {
    return await scanRepository.exportData(params);
  }
}
