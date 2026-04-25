import 'package:expense_tracker/core/database/app_database.dart';

class DeleteAccountLocalDataSource {
  Future<void> deleteLocalDatabaseFile() async {
    final databaseFile = await AppDatabase.getDatabaseFile();
    if (await databaseFile.exists()) {
      await databaseFile.delete();
    }
  }
}
