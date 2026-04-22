import 'package:jccm_espacio_ciudadano/core/errors/app_error.dart';

/// A discriminated union that wraps either a successful value of type `T`
/// or a domain error of type [AppError].
///
/// Use `Result` as the return type of any use-case or repository method that
/// can fail in a recoverable way instead of throwing exceptions.
sealed class Result<T> {
  const Result();
}

/// Represents a successful outcome carrying [value].
final class Success<T> extends Result<T> {
  const Success(this.value);

  final T value;
}

/// Represents a failed outcome carrying an [AppError].
final class Failure<T> extends Result<T> {
  const Failure(this.error);

  final AppError error;
}
