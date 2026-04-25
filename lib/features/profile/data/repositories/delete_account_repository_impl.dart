import 'package:expense_tracker/core/database/app_database.dart';
import 'package:expense_tracker/core/di/service_locator.dart';
import 'package:expense_tracker/core/error/result.dart';
import 'package:expense_tracker/features/auth/domain/auth_repository.dart';
import 'package:expense_tracker/features/profile/data/datasources/delete_account_local_data_source.dart';
import 'package:expense_tracker/features/profile/domain/repositories/delete_account_repository.dart';
import 'package:expense_tracker/features/profile/domain/repositories/drive_repository.dart';

final class DeleteAccountRepositoryImpl implements DeleteAccountRepository {
  DeleteAccountRepositoryImpl(
    this._localDataSource,
    this._driveRepository,
    this._authRepository,
  );

  final DeleteAccountLocalDataSource _localDataSource;
  final DriveRepository _driveRepository;
  final AuthRepository _authRepository;

  @override
  ResultVoid deleteAccount() async {
    try {
      try {
        await _driveRepository.deleteFile(AppDatabase.dbFileName);
      } catch (_) {
        // Best effort only. Local cleanup still continues.
      }

      // Close cubits + DB, then delete the file, then rebuild the locator.
      await resetServiceLocator();
      await _localDataSource.deleteLocalDatabaseFile();

      final signOutResult = await _authRepository.signOut();
      return signOutResult.fold(
        (_) => const Success(null),
        (failure) => Error(failure),
      );
    } catch (e) {
      return Error(DatabaseFailure(e.toString()));
    }
  }
}
