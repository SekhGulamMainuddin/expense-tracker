import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/features/profile/presentation/cubit/delete_account_state.dart';

class DeleteAccountCubit extends Cubit<DeleteAccountState> {
  DeleteAccountCubit() : super(const DeleteAccountState());

  Future<void> deleteAccount() async {
    emit(const DeleteAccountState(isDeleting: true));

    // Simulate network delay for account deletion
    await Future.delayed(const Duration(seconds: 2));

    emit(const DeleteAccountState(isDeleting: false, isSuccess: true));
  }
}
