import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/features/profile/presentation/cubit/google_drive_state.dart';

class GoogleDriveCubit extends Cubit<GoogleDriveState> {
  GoogleDriveCubit() : super(const GoogleDriveState());

  Future<void> grantAccess() async {
    emit(const GoogleDriveState(isGranting: true));

    // Simulate Google OAuth / Permission process
    await Future.delayed(const Duration(seconds: 2));

    emit(const GoogleDriveState(isGranting: false, isSuccess: true));
  }
}
