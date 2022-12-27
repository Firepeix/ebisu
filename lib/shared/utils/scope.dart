typedef Transform<T, O> = O Function(T it);

Scope<T>? scope<T>(T? value) {
  return value != null ? Scope(value): null;
}

class Scope<T> {
  final T _value;

  Scope(this._value);

  O run<O>(Transform<T,O> transform) {
    return transform.call(_value);
  }
}


