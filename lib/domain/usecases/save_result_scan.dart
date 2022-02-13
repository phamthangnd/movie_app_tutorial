import 'package:dartz/dartz.dart';
import 'package:movieapp/domain/entities/record_entity.dart';
import 'package:movieapp/domain/entities/save_result_params.dart';
import 'package:movieapp/domain/repositories/scan_repository.dart';

import '../entities/app_error.dart';
import 'usecase.dart';

class SaveResultScan extends UseCase<RecordEntity, SaveResultScanParams> {
  final ScanRepository scanRepository;

  SaveResultScan(this.scanRepository);

  @override
  Future<Either<AppError, RecordEntity>> call(SaveResultScanParams params) async {
    return await scanRepository.saveResultScan(params.data);
  }
}
