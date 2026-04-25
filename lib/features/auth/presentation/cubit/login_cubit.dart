import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/core/database/app_database.dart';
import 'package:expense_tracker/core/di/service_locator.dart';
import 'package:expense_tracker/core/phoenix.dart';
import 'package:expense_tracker/features/auth/presentation/cubit/login_state.dart';
import 'package:expense_tracker/features/profile/domain/repositories/drive_repository.dart';

import '../../domain/auth_repository.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authRepository, this._driveRepository) : super(LoginInitial());

  final AuthRepository _authRepository;
  final DriveRepository _driveRepository;

  Future<void> signInWithGoogle() async {
    emit(LoginLoading());

    final result = await _authRepository.signInWithGoogle();

    await result.fold(
      (_) async {
        final isGranted = await _authRepository.isDrivePermissionGranted();
        if (!isGranted) {
          final requestResult = await _authRepository.requestDrivePermission();
          await requestResult.fold(
            (_) async => _restoreBackup(),
            (failure) async {
              await _authRepository.signOut();
              emit(LoginFailure('Google Drive permission is required for backup.'));
            },
          );
        } else {
          await _restoreBackup();
        }
      },
      (failure) async => emit(LoginFailure(failure.message)),
    );
  }

  Future<void> _restoreBackup() async {
    emit(LoginSyncing());
    final result = await _driveRepository.downloadBinary(AppDatabase.dbFileName);

    await result.fold(
      (bytes) async {
        if (bytes != null) {
          await resetServiceLocator();
          final dbFile = await AppDatabase.getDatabaseFile();
          await dbFile.writeAsBytes(bytes);
          Phoenix.rebirth();
        }
        emit(LoginSuccess());
      },
      (_) async {
        // Even if download fails (e.g., no connection), let the user log in.
        emit(LoginSuccess());
      },
    );
  }
}
