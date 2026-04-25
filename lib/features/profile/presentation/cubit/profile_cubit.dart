import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:expense_tracker/core/di/service_locator.dart';
import 'package:expense_tracker/core/database/app_database.dart';
import 'package:expense_tracker/core/phoenix.dart';
import 'package:expense_tracker/features/profile/domain/repositories/drive_repository.dart';
import 'package:expense_tracker/features/profile/presentation/cubit/profile_state.dart';

import '../../../auth/domain/auth_repository.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._authRepository, this._driveRepository)
      : super(ProfileInitial());

  final AuthRepository _authRepository;
  final DriveRepository _driveRepository;

  Future<void> checkDriveStatus() async {
    emit(ProfileLoading());
    final isGranted = await _authRepository.isDrivePermissionGranted();
    final user = firebase.FirebaseAuth.instance.currentUser;

    emit(
      ProfileLoaded(
        isDriveConnected: isGranted,
        name: user?.displayName ?? 'User',
        email: user?.email ?? '',
        profileImageUrl: user?.photoURL ?? '',
      ),
    );
  }

  Future<void> connectDrive() async {
    if (state is! ProfileLoaded) return;
    final currentState = state as ProfileLoaded;

    emit(ProfileLoading());
    final result = await _authRepository.requestDrivePermission();

    result.fold(
          (_) => emit(currentState.copyWith(isDriveConnected: true)),
          (failure) => emit(ProfileFailure(failure.message)),
    );
  }

  Future<void> signOut() async {
    emit(ProfileLoading());
    final result = await _authRepository.signOut();

    result.fold(
          (_) => emit(ProfileInitial()),
          (failure) => emit(ProfileFailure(failure.message)),
    );
  }

  Future<void> syncData() async {
    if (state is! ProfileLoaded) return;
    final currentState = state as ProfileLoaded;

    emit(currentState.copyWith(isSyncing: true));

    try {
      final dbFile = await AppDatabase.getDatabaseFile();
      if (!await dbFile.exists()) {
        emit(ProfileFailure('Database file not found'));
        return;
      }

      final bytes = await dbFile.readAsBytes();
      final result = await _driveRepository.uploadBinary(
        fileName: AppDatabase.dbFileName,
        bytes: bytes,
      );

      result.fold(
            (_) => emit(currentState.copyWith(isSyncing: false)),
            (failure) => emit(ProfileFailure(failure.message)),
      );
    } catch (e) {
      emit(ProfileFailure('Backup failed: ${e.toString()}'));
    }
  }

  Future<void> syncDataInBackground() async {
    final isGranted = await _authRepository.isDrivePermissionGranted();
    if (!isGranted) return;

    try {
      final dbFile = await AppDatabase.getDatabaseFile();
      if (!await dbFile.exists()) return;

      final bytes = await dbFile.readAsBytes();
      await _driveRepository.uploadBinary(
        fileName: AppDatabase.dbFileName,
        bytes: bytes,
      );
    } catch (_) {
      // Ignore background errors
    }
  }

  Future<void> restoreData() async {
    if (state is! ProfileLoaded) return;
    final currentState = state as ProfileLoaded;

    emit(currentState.copyWith(isSyncing: true));

    try {
      final result = await _driveRepository.downloadBinary(
        AppDatabase.dbFileName,
      );

      await result.fold((bytes) async {
        if (bytes == null) {
          emit(ProfileFailure('No backup found on Google Drive'));
          return;
        }

        // Reset the entire service locator so every DB-dependent singleton
        // (DAOs, data sources, repositories, cubits) rebinds to a fresh
        // AppDatabase after the file is swapped.
        await resetServiceLocator();

        final dbFile = await AppDatabase.getDatabaseFile();
        await dbFile.writeAsBytes(bytes);

        // Force the widget tree to remount so all BlocBuilders re-resolve
        // getIt<...>() against the new singletons.
        Phoenix.rebirth();
      }, (failure) async => emit(ProfileFailure(failure.message)));
    } catch (e) {
      emit(ProfileFailure('Restore failed: ${e.toString()}'));
    }
  }
}
