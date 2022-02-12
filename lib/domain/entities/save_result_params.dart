import 'package:equatable/equatable.dart';

class SaveResultScanParams extends Equatable {
  final String data;

  const SaveResultScanParams(this.data);

  @override
  List<Object> get props => [data];
}
