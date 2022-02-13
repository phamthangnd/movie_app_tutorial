import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:movieapp/domain/entities/app_error.dart';
import 'package:movieapp/domain/entities/record_entity.dart';
import 'package:movieapp/domain/usecases/get_list_records.dart';
import 'package:movieapp/presentation/blocs/loading/loading_cubit.dart';

part 'get_record_state.dart';

class GetRecordCubit extends Cubit<GetRecordState> {
  final GetListRecord getListRecord;
  final LoadingCubit loadingCubit;

  GetRecordCubit({
    required this.getListRecord,
    required this.loadingCubit,
  }) : super(GetRecordInitial());

  void saveDataResultScan({DateTime? dateTime}) async {
    loadingCubit.show();
    final saveDataEither = await getListRecord(dateTime);
    emit(saveDataEither.fold(
          (l) {
        print(l.appErrorType);
        return GetRecordError(l.appErrorType);
      },
          (list) {
        return GetRecordSuccess(list);
      },
    ));
    loadingCubit.hide();
  }
}
