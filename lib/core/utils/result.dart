import '../error/failure.dart';

/// A tiny, dependency-free result type used by repositories and use cases.
///
/// Instead of throwing, the data/domain layers return a [Result] that is either
/// [Ok] (holding a value) or [Err] (holding a [Failure]). Consume it with a
/// switch and pattern matching:
///
///   switch (result) {
///     case Ok(value: final user): // success
///     case Err(failure: final f): // failure, f.message
///   }
sealed class Result<T> {
  const Result();
}

final class Ok<T> extends Result<T> {
  const Ok(this.value);
  final T value;
}

final class Err<T> extends Result<T> {
  const Err(this.failure);
  final Failure failure;
}
