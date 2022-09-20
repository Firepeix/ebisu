typedef ResultMapper<B, T> = T Function(B value);


abstract class ResultError {
  final String? message;
  final String code;
  final Details? details;

  const ResultError(this.message, this.code, this.details);
}

class Details {
  String? messageAddon;
  dynamic data;

  Details({this.messageAddon, this.data});
}

class Result<V, E extends ResultError> {
  V? _value;
  E? _error;

  V? get value => _value;

  E? get error => _error;

  Result(this._value, this._error);

  bool hasError() {
    return _error != null;
  }

  bool isOk() {
    return !hasError();
  }

  V unwrap() {
    return _value!;
  }

  Result<V, NewError> subError<NewError extends ResultError>(NewError error) {
    return Result(_value, _error != null ? error : null);
  }

  Result<B, E> map<B>(ResultMapper<V, B> mapper) {
    if (isOk()) {
      return Result(mapper(_value!), _error);
    }

    return Result(null, _error);
  }

  Result<B, E> mapTo<B>() {
    return map((value) => value as B);
  }

  Result<V, B> mapError<B extends ResultError>(ResultMapper<E, B> mapper) {
    if (hasError()) {
      return Result(null, mapper(_error!));
    }
    return Result(_value, null);
  }

  Result<V, B> mapErrorTo<B extends ResultError>() {
    return mapError((value) => value as B);
  }
}