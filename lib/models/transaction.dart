import 'package:drift/drift.dart';

class Transactions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get description => text().withLength(max: 250)();
  // ignore: non_constant_identifier_names
  IntColumn get category_id => integer()();
  // ignore: non_constant_identifier_names
  DateTimeColumn get transaction_date => dateTime()();
  IntColumn get amount => integer()();

  // ignore: non_constant_identifier_names
  DateTimeColumn get created_at => dateTime()();
  // ignore: non_constant_identifier_names
  DateTimeColumn get updated_at => dateTime()();
  // ignore: non_constant_identifier_names
  DateTimeColumn get deleted_at => dateTime().nullable()();
}
