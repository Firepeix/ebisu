typedef MatchFunction<T> = T Function();
typedef AsyncMatchFunction<T> = Future<T> Function();

class Matcher<T, R> {
  T _value;
  MatchFunction<R>? _else;
  AsyncMatchFunction<R>? _elseAsync;

  Matcher(this._value);

  static Matcher when<V>(V value) => Matcher(value);

  static P matchWhen<T, P> (T value, Map<T, P> patterns, {P? base}) {
    final found = patterns[value];
    if (found == null) {
      if(base != null) {
        return base;
      }
      throw Exception("Padrão não exaustivo para o valor $value");
    }

    return found;
  }

  Matcher or(MatchFunction<R> or) {
    _else = or;
    return this;
  }
  Matcher orAsync(AsyncMatchFunction<R> or) {
    _elseAsync = or;
    return this;
  }

  R match(Map<T, MatchFunction<R>> options) {
    final match = options[_value];
    if (match != null) {
      return match.call();
    }
    if (_else != null) {
      return _else!.call();
    }

    throw Error.safeToString("Match deve ser exaustivo");
  }

  Future<R> matchAsync(Map<T, AsyncMatchFunction<R>> options) async {
    final match = options[_value];
    if (match != null) {
      return await match.call();
    }
    if (_elseAsync != null) {
      return await _elseAsync!.call();
    }

    throw Error.safeToString("Match deve ser exaustivo");
  }
}