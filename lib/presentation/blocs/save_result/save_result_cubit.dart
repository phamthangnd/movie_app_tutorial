import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:movieapp/domain/entities/app_error.dart';
import 'package:movieapp/domain/entities/save_result_params.dart';
import 'package:movieapp/domain/usecases/save_result_scan.dart';
import 'package:movieapp/presentation/blocs/loading/loading_cubit.dart';

part 'save_result_state.dart';

class SaveResultCubit extends Cubit<SaveResultState> {
  final SaveResultScan saveResultScan;
  final LoadingCubit loadingCubit;

  SaveResultCubit({
    required this.saveResultScan,
    required this.loadingCubit,
  }) : super(SaveResultInitial());

  void saveDataResultScan(String data) async {
    loadingCubit.show();
    final saveDataEither = await saveResultScan(SaveResultScanParams(data));
    emit(saveDataEither.fold(
          (l) => SaveResultError(l.appErrorType),
          (account) {
        return SaveResultSuccess(
        );
      },
    ));
    loadingCubit.hide();
  }
}
