typedef ResultFuture<T> = Future<Result<T, Failure>>;
typedef ResultVoid = ResultFuture<void>;

sealed class Result<S, F extends Failure> {
  const Result();

  bool get isSuccess => this is Success<S, F>;
  bool get isFailure => this is Error<S, F>;

  S? get dataOrNull => switch (this) {
    Success(data: final d) => d,
    Error() => null,
  };

  F? get failureOrNull => switch (this) {
    Success() => null,
    Error(failure: final f) => f,
  };

  T fold<T>(T Function(S data) onSuccess, T Function(F failure) onFailure) {
    return switch (this) {
      Success(data: final d) => onSuccess(d),
      Error(failure: final f) => onFailure(f),
    };
  }
}

class Success<S, F extends Failure> extends Result<S, F> {
  final S data;
  const Success(this.data);
}

class Error<S, F extends Failure> extends Result<S, F> {
  final F failure;
  const Error(this.failure);
}

abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server Error']);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication Failed']);
}

class DatabaseFailure extends Failure {
  const DatabaseFailure([super.message = 'Database Error']);
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'Something went wrong']);
}

class DriveFailure extends Failure {
  const DriveFailure([super.message = 'Google Drive Error']);
}
