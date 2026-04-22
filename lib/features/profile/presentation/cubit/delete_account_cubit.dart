import 'package:bloc/bloc.dart';
import 'package:expense_tracker/features/profile/domain/repositories/delete_account_repository.dart';

part 'delete_account_state.dart';

class DeleteAccountCubit extends Cubit<DeleteAccountState> {
  DeleteAccountCubit(this._deleteAccountRepository) : super(DeleteAccountInitial());

  final DeleteAccountRepository _deleteAccountRepository;

  Future<void> deleteAccount() async {
    emit(DeleteAccountDeleting());

    final result = await _deleteAccountRepository.deleteAccount();
    result.fold(
      (_) => emit(DeleteAccountSuccess()),
      (failure) => emit(DeleteAccountFailure(failure.message)),
    );
  }
}
