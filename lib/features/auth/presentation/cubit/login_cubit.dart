import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/features/auth/presentation/cubit/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState());

  Future<void> signInWithGoogle() async {
    emit(const LoginState(isAuthenticating: true));

    // Simulate OAuth Delay
    await Future.delayed(const Duration(seconds: 2));

    // In a real app, you'd integrate google_sign_in package here
    emit(const LoginState(isAuthenticating: false, isSuccess: true));
  }
}
