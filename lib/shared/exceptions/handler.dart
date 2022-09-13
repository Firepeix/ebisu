import 'package:ebisu/shared/dependency/dependency_container.dart';
import 'package:ebisu/shared/exceptions/result.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

abstract class ExceptionHandlerInterface {
  V? expect<V, E extends ResultError>(Result<V, E> result);
  // TODO ADD UNWRAP
  // TODO ADD IGNORE
  // TODO ADD GET ERROR
}

@Singleton(as: ExceptionHandlerInterface)
class ExceptionHandler implements ExceptionHandlerInterface {

  void _displayError (ResultError error, BuildContext? context, {behavior: SnackBarBehavior.fixed}) {
    if (context != null) {
      ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
      messenger.showSnackBar(SnackBar(
          content: Text(error.message),
          duration: Duration(seconds: 4),
          backgroundColor: Colors.red,
          behavior: behavior
      ));
    }
  }

  @override
  V? expect<V, E extends ResultError>(Result<V, E> result) {
    if (result.hasError()) {
      _displayError(result.error(), DependencyManager.getContext());
      return null;
    }

    return result.unwrap();
  }
}