import 'package:movieapp/data/models/record_model.dart';

abstract class RecordsDatabase {
  Future<List<RecordModel>> allRecords();
  Future<RecordModel> insertTodo(final RecordModel todoEntity, final int userId);
  Future<void> updateTodo(final RecordModel todoEntity);
  Future<void> deleteTodo(final int id);
}