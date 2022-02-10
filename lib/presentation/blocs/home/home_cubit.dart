import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<int> {
  HomeCubit() : super(0);

  Future<void> pageChanged(int index) async {
    emit(index);
  }
}
