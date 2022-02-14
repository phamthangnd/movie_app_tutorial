import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:movieapp/domain/entities/app_error.dart';
import 'package:movieapp/domain/entities/record_entity.dart';
import 'package:movieapp/domain/usecases/export_record.dart';
import 'package:movieapp/presentation/blocs/loading/loading_cubit.dart';

part 'exported_record_state.dart';

class ExportedRecordCubit extends Cubit<ExportedRecordState> {
  final ExportedRecord exportedRecord;
  final LoadingCubit loadingCubit;

  ExportedRecordCubit({
    required this.exportedRecord,
    required this.loadingCubit,
  }) : super(ExportedRecordInitial());

  void exportRecord(List<RecordEntity>list) async {
    loadingCubit.show();
    final saveDataEither = await exportedRecord(list);
    emit(saveDataEither.fold(
          (l) {
        return ExportedRecordError(l.appErrorType);
      },
          (r) {
        return ExportedRecordSuccess();
      },
    ));
    loadingCubit.hide();
  }

}
