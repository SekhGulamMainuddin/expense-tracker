import 'package:expense_tracker/core/database/app_database.dart';
import 'package:expense_tracker/core/di/service_locator.dart';

class DeleteAccountLocalDataSource {
  Future<void> deleteLocalDatabase() async {
    final database = getIt<AppDatabase>();
    final databaseFile = await AppDatabase.getDatabaseFile();

    await database.close();
    if (await databaseFile.exists()) {
      await databaseFile.delete();
    }
  }
}
