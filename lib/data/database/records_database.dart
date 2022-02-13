import 'package:movieapp/data/models/record_model.dart';

abstract class RecordsDatabase {
  Future<List<RecordModel>> allRecords(final int userId);
  Future<List<RecordModel>> getListRecordByDate(DateTime? dateTime, final int userId);
  Future<RecordModel> insertRecord(final RecordModel record, final int userId);
  Future<void> updateRecord(final RecordModel record);
  Future<void> deleteRecord(final int id);
}