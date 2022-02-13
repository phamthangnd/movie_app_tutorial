import 'package:movieapp/data/models/record_model.dart';

abstract class RecordsDatabase {
  Future<List<RecordModel>> allRecords();
  Future<RecordModel> insertRecord(final RecordModel record, final int userId);
  Future<void> updateRecord(final RecordModel record);
  Future<void> deleteRecord(final int id);
}