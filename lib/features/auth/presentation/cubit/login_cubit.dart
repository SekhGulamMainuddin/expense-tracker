import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/features/auth/presentation/cubit/login_state.dart';

import '../../domain/auth_repository.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authRepository) : super(LoginInitial());

  final AuthRepository _authRepository;

  Future<void> signInWithGoogle() async {
    emit(LoginLoading());

    final result = await _authRepository.signInWithGoogle();

    await result.fold(
          (userCredential) async {
        final isGranted = await _authRepository.isDrivePermissionGranted();
        if (!isGranted) {
          final requestResult = await _authRepository.requestDrivePermission();
          await requestResult.fold(
                (_) async => emit(LoginSuccess()),
                (failure) async {
              await _authRepository.signOut();
              emit(LoginFailure('Google Drive permission is required for backup.'));
            },
          );
        } else {
          emit(LoginSuccess());
        }
      },
          (failure) async => emit(LoginFailure(failure.message)),
    );
  }
}
