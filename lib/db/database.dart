import 'dart:io';

import 'package:catat_duit/models/category.dart';
import 'package:catat_duit/models/transaction.dart';
import 'package:catat_duit/models/transaction_with_category.dart';
import 'package:drift/drift.dart';
// These imports are used to open the database
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

@DriftDatabase(
  // relative import for the drift file. Drift also supports `package:`
  // imports
  tables: [Categories, Transactions],
)
class AppDb extends _$AppDb {
  AppDb() : super(_openConnection());

  @override
  int get schemaVersion => 6;

  //CRUD category

  Future<List<Category>> getAllCategoryRepo(int type) async {
    return await (select(categories)..where((tbl) => tbl.type.equals(type)))
        .get();
  }

  Future updateCategoryRepo(int id, String name) async {
    return (update(categories)..where((tbl) => tbl.id.equals(id)))
        .write(CategoriesCompanion(name: Value(name)));
  }

  Future deleteCategoryRepo(int id) async {
    return (delete(categories)..where((tbl) => tbl.id.equals(id))).go();
  }

  // Transaction

  Stream<List<TransactionWithCategory>> getTransactionByDateRepo(
      DateTime date) {
    final query = (select(transactions).join([
      innerJoin(categories, categories.id.equalsExp(transactions.category_id))
    ])
      ..where(transactions.transaction_date.equals(date)));
    return query.watch().map((rows) {
      return rows.map((row) {
        return TransactionWithCategory(
            row.readTable(transactions), row.readTable(categories));
      }).toList();
    });
  }

  Future updateTransactionRepo(int id, int amount, int categoryId,
      DateTime transactionDate, String nameDetail) async {
    return (update(transactions)..where((tbl) => tbl.id.equals(id))).write(
        TransactionsCompanion(
            description: Value(nameDetail),
            amount: Value(amount),
            category_id: Value(categoryId),
            transaction_date: Value(transactionDate)));
  }

  Future deleteTransactionRepo(int id) async {
    return (delete(transactions)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<int> getTotalIncomeByCategoryRepo(int type) async {
    final query = 'SELECT SUM(transactions.amount) as total_income '
        'FROM transactions '
        'INNER JOIN categories ON categories.id = transactions.category_id '
        'WHERE categories.type = $type ';

    final result = await customSelect(query).map((QueryRow row) {
      return row.read<int>('total_income');
    }).getSingle();

    return result;
  }

  Future<int> getTotalExpenseByCategoryRepo(int type) async {
    final query = 'SELECT SUM(transactions.amount) as total_expense '
        'FROM transactions '
        'INNER JOIN categories ON categories.id = transactions.category_id '
        'WHERE categories.type = $type ';

    final result = await customSelect(query).map((QueryRow row) {
      return row.read<int>('total_expense');
    }).getSingle();

    return result;
  }

  Future<int> getTotalIncomeByDate(DateTime date) async {
    final query = customSelect(
      'SELECT SUM(amount) as total_income FROM transactions '
      'WHERE transactions_date = :date '
      'AND (SELECT type FROM categories WHERE categories.id = transactions.category_id) = 1',
      variables: [Variable.withDateTime(date)],
    ).map((row) => row.read<int>('total_income')).getSingle();

    return query;
  }

  Future<int> getTotalExpenseByDate(DateTime date) async {
    final query = customSelect(
      'SELECT SUM(amount) as total_expense FROM transactions '
      'WHERE transactions_date = :date '
      'AND (SELECT type FROM categories WHERE categories.id = transactions.category_id) = 2',
      variables: [Variable.withDateTime(date)],
    ).map((row) => row.read<int>('total_expense')).getSingle();

    return query;
  }
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));

    return NativeDatabase(file);
  });
}
