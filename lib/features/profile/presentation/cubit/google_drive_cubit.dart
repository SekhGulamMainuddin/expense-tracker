import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/features/profile/presentation/cubit/google_drive_state.dart';

class GoogleDriveCubit extends Cubit<GoogleDriveState> {
  GoogleDriveCubit() : super(GoogleDriveState());

  Future<void> grantAccess() async {
    emit(GoogleDriveState(isGranting: true));

    // Simulate Google OAuth / Permission process
    await Future.delayed(const Duration(seconds: 2));

    emit(GoogleDriveState(isGranting: false, isSuccess: true));
  }
}
