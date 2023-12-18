typedef Transform<T, O> = O Function(T it);
typedef NullSafeTransform<T extends Object, O> = O Function(T it);

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

extension ScopeExtension<T extends Object> on T {
  R let<R>(NullSafeTransform<T, R> transform) {
    return transform.call(this);
  }
}

//extension DynamicScopeExtension on dynamic {
//  R? let<R>(Transform<dynamic, R> transform) {
//    if(this == null) {
//      return null;
//    }
//    return transform.call(this);
//  }
//}

