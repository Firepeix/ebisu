import 'package:ebisu/shared/exceptions/result_error.dart';

typedef ResultMapper<B, T> = T Function(B value);

typedef MatchOk<T, R> = R Function(T value);
typedef WillMatchOk<T, R> = Future<R> Function(T value);

typedef MatchErr<E extends ResultError, R> = R Function(E error);
typedef WillMatchErr<E extends ResultError, R> = Future<R> Function(E error);

abstract class Result<V, E extends ResultError> {
  R let<R>({MatchOk<V, R>? ok, MatchErr<E, R>? err});

  Future<R> willLet<R>({WillMatchOk<V, R>? ok, WillMatchErr<E, R>? err});

  R match<R>({required MatchOk<V, R> ok, required MatchErr<E, R> err});

  Result<B, E> andThen<B, E extends ResultError>(ResultMapper<V, Result<B, E>> mapper);

  Future<Result<B, E>> willThen<B, E extends ResultError>(ResultMapper<V, Future<Result<B, E>>> mapper);

  Future<R> willMatch<R>({required WillMatchOk<V, R> ok, required WillMatchErr<E, R> err});

  V unwrap<V>();

  Result<B, E> map<B, E extends ResultError>(ResultMapper<V, B> mapper);

  Result<B, ME> mapErr<B, ME extends ResultError>(ResultMapper<E, ME> mapper);

  Result<B, ME> mapErrTo<B, ME extends ResultError>(ME mapper);

  R to<R>({required R ok, required R err});
}

class Ok<V, E extends ResultError> implements Result<V, E > {
  V _value;

  Ok(this._value);

  R let<R>({MatchOk<V, R>? ok, MatchErr<E, R>? err}) {
    assert(ok != null || err != null, "Ok ou Err deve ser mapeados para o Match");

    if (ok != null) {
      return ok.call(_value);
    }

    return null as R;
  }

  Future<R> willLet<R>({WillMatchOk<V, R>? ok, WillMatchErr<E, R>? err}) async {
    assert(ok != null || err != null, "Ok ou Err deve ser mapeados para o Match");

    if (ok != null) {
      return await ok.call(_value);
    }

    return Future.value(null);
  }

  R match<R>({required MatchOk<V, R> ok, required MatchErr<E, R> err}) {
    return ok.call(_value);
  }

  Future<R> willMatch<R>({required WillMatchOk<V, R> ok, required WillMatchErr<E, R> err}) async {
    return await ok.call(_value);
  }

  V unwrap<V>() {
    return _value as V;
  }

  Result<B, E> map<B, E extends ResultError>(ResultMapper<V, B> mapper) {
    return Ok<B, E>(mapper(_value));
  }

  Result<B, ME> mapErr<B, ME extends ResultError>(ResultMapper<E, ME> mapper) {
    return Ok<B, ME>(_value as B);
  }

  @override
  Result<B, ME> mapErrTo<B, ME extends ResultError>(ME mapper) {
    return Ok<B, ME>(_value as B);
  }

  @override
  Result<B, E> andThen<B, E extends ResultError>(ResultMapper<V, Result<B, E>> mapper) {
    return mapper(_value);
  }

  @override
  Future<Result<B, E>> willThen<B, E extends ResultError>(
      ResultMapper<V, Future<Result<B, E>>> mapper) async {
    return await mapper(_value);
  }

  @override
  R to<R>({required R ok, required R err}) {
    return ok;
  }
}

class Err<V, E extends ResultError> implements Result<V, E> {
  E _value;

  Err(this._value);

  R let<R>({MatchOk<V, R>? ok, MatchErr<E, R>? err}) {
    assert(ok != null || err != null, "Ok ou Err deve ser mapeados para o Match");

    if (err != null) {
      return err.call(_value);
    }

    return null as R;
  }

  Future<R> willLet<R>({WillMatchOk<V, R>? ok, WillMatchErr<E, R>? err}) async {
    assert(ok != null || err != null, "Ok ou Err deve ser mapeados para o Match");

    if (err != null) {
      return await err.call(_value);
    }

    return Future.value(null);
  }

  R match<R>({required MatchOk<V, R> ok, required MatchErr<E, R> err}) {
    return err.call(_value);
  }

  Future<R> willMatch<R>({required WillMatchOk<V, R> ok, required WillMatchErr<E, R> err}) async {
    return await err.call(_value);
  }

  V unwrap<V>() {
    throw Error.safeToString("Unwrap em Error");
  }

  Result<B, E> map<B, E extends ResultError>(ResultMapper<V, B> mapper) {
    return Err(_value as E);
  }

  @override
  Result<B, ME> mapErr<B, ME extends ResultError>(ResultMapper<E, ME> mapper) {
    return Err<B, ME>(mapper(_value));
  }

  @override
  Result<B, ME> mapErrTo<B, ME extends ResultError>(ME mapper) {
    return Err(mapper);
  }

  @override
  Result<B, E> andThen<B, E extends ResultError>(ResultMapper<V, Result<B, E>> mapper) {
    return Err(_value as E);
  }

  Future<Result<B, E>> willThen<B, E extends ResultError>(ResultMapper<V, Future<Result<B, E>>> mapper) {
    return Future.value(Err(_value as E));
  }

  R to<R>({required R ok, required R err}) {
    return err;
  }
}
