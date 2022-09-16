typedef ResultMapper<B, T> = T Function(B value);


abstract class ResultError {
  final String message;
  final String code;

  ResultError(this.message, this.code);
}

class Details {
  String? messageAddon;
  dynamic data;

  Details({this.messageAddon, this.data});
}

class Result<V, E extends ResultError> {
  V? _value;
  E? _error;
  Details? details;

  Result(this._value, this._error, {this.details});

  bool hasError() {
    return _error != null;
  }

  bool isSuccessful() {
    return !hasError();
  }

  V unwrap() {
    return _value!;
  }

  E error() {
    return _error!;
  }

  Result<V, NewError> subError<NewError extends ResultError>(NewError error) {
    return Result(_value, _error != null ? error : null, details: details);
  }

  Result<B, E> map<B>(ResultMapper<V, B> mapper) {
    if (isSuccessful()) {
      return Result(mapper(_value!), _error, details: details);
    }

    return Result(null, _error, details: details);
  }

  Result<B, E> mapTo<B>() {
    return map((value) => value as B);
  }

  Result<V, B> mapError<B extends ResultError>(ResultMapper<E, B> mapper) {
    if (hasError()) {
      return Result(null, mapper(_error!), details: details);
    }
    return Result(_value, null, details: details);
  }

  Result<V, B> mapErrorTo<B extends ResultError>() {
    return mapError((value) => value as B);
  }
}