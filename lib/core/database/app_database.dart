import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:expense_tracker/core/database/tables/expense_table.dart';
import 'package:expense_tracker/core/database/tables/key_value_store_table.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'dao/expense_dao.dart';
import 'dao/key_value_store_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Expenses, KeyValueStore],
  daos: [ExpenseDao, KeyValueStoreDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.createTable(keyValueStore);
        }
      },
    );
  }

  static const String dbFileName = 'db.sqlite';

  static Future<File> getDatabaseFile() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    return File(p.join(dbFolder.path, dbFileName));
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final file = await AppDatabase.getDatabaseFile();

    return NativeDatabase.createInBackground(file);
  });
}
