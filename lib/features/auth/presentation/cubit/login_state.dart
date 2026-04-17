class LoginState {
  final bool isAuthenticating;
  final String? errorMessage;
  final bool isSuccess;

  const LoginState({
    this.isAuthenticating = false,
    this.errorMessage,
    this.isSuccess = false,
  });
}
