typedef ResultMapper<B, T> = T Function(B value);

abstract class ResultError {
  final String? message;
  final String code;
  final Details? details;

  const ResultError(this.message, this.code, this.details);
}

class UnknownError extends ResultError {
  const UnknownError(details) : super("Ops! Ocorreu um erro. Tente Novamente mais tarde.", "FU1", details);
}

class Details {
  String? messageAddon;
  dynamic data;

  Details({this.messageAddon, this.data});
}

typedef MatchOk<T, R> = R Function(T value);
typedef WillMatchOk<T, R> = Future<R> Function(T value);

typedef MatchErr<E extends ResultError, R> = R Function(E error);
typedef WillMatchErr<E extends ResultError, R> = Future<R> Function(E error);

abstract class ResultValue {}

class Ok<V> implements ResultValue {
  final V value;

  Ok(this.value);
}

class Err<E extends ResultError> implements ResultValue {
  final E value;
  Err(this.value);
}

class Result<V, E extends ResultError> {
  ResultValue _value;

  ResultValue getValue() => _value;

  Result(this._value);

  Result.ok(V _value) : this(Ok(_value));

  Result.err(E _error) : this(Err(_error));

  Result<T, Er> to<T, Er extends ResultError>() {
    return Result(_value);
  }

  bool hasError() => _value is Err;

  bool isOk() => !hasError();

  R match<R>({MatchOk<V, R>? ok, MatchErr<E, R>? err}) {
    assert(ok != null || err != null, "Ok ou Err deve ser mapeados para o Match");

    if (ok != null && isOk()) {
      return ok.call((_value as Ok<V>).value);
    }

    if (err != null && hasError()) {
      return err.call((_value as Err<E>).value);
    }

    return null as R;
  }

  Future<R> willMatch<R>({WillMatchOk<V, R>? ok, WillMatchErr<E, R>? err}) async {
    assert(ok != null || err != null, "Ok ou Err deve ser mapeados para o Match");

    if (ok != null && isOk()) {
      return await ok.call((_value as Ok<V>).value);
    }

    if (err != null && hasError()) {
      return await err.call((_value as Err<E>).value);
    }

    return Future.value(null);
  }

  V unwrap() {
    return (_value as Ok<V>).value;
  }

  Result<V, NewError> subError<NewError extends ResultError>(NewError error) {
    if (_value is Err) {
      return Result.err(error);
    }

    return Result(_value);
  }

  Result<B, E> map<B>(ResultMapper<V, B> mapper) {
    if (isOk()) {
      final result = _value as Ok<V>;
      return Result.ok(mapper(result.value));
    }

    return Result(_value);
  }

  Result<B, E> mapTo<B>() {
    return map((value) => value as B);
  }

  Result<V, B> mapError<B extends ResultError>(ResultMapper<E, B> mapper) {
    if (hasError()) {
      final result = _value as Err<E>;
      return Result.err(mapper(result.value));
    }
    return Result(_value);
  }

  Result<V, B> mapErrorTo<B extends ResultError>() {
    return mapError((value) => value as B);
  }
}
