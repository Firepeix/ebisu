abstract class ResultError {
  final String message;
  final String code;
  final dynamic details;

  ResultError(this.message, this.code, this.details);
}

class Result<V, E extends ResultError> {
  V? _value;
  E? _error;

  Result(this._value, this._error);

  bool hasError() {
    return _error != null;
  }

  V unwrap() {
    return _value!;
  }

  E error() {
    return _error!;
  }

  Result<V, NewError> subError<NewError extends ResultError>(NewError error) {
    return Result(_value, _error != null ? error : null);
  }
}