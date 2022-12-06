import 'package:ebisu/shared/exceptions/handler.dart';
import 'package:ebisu/shared/exceptions/result.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

abstract class ExceptionHandlerServiceInterface {
  T? wrap<T>(Function callback, {String? errorContext});
  Future<T?> wrapAsync<T>(Function callback, {String? errorContext});
  void displayError(String message, BuildContext context, {behavior: SnackBarBehavior.fixed});
}

@Singleton(as: ExceptionHandlerServiceInterface)
class ExceptionHandlerService implements ExceptionHandlerServiceInterface {
  final ExceptionHandlerInterface _handler;

  ExceptionHandlerService(this._handler);

  @override
  T? wrap<T>(Function callback, {String? errorContext}) {
    try {
      return callback();
    } catch (error) {
      final _error = _handler.parseError(error, errorContext: errorContext);
      _handler.expect(Result.err(_error));
    }
  }

  @override
  Future<T?> wrapAsync<T>(Function callback, {String? errorContext}) async {
    try {
      return await callback();
    } catch (error) {
      final _error = _handler.parseError(error, errorContext: errorContext);
      _handler.expect(Result.err(_error));
    }
  }

  void displayError (String message, BuildContext context, {behavior: SnackBarBehavior.fixed}) {
    ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(SnackBar(
        content: Text('Erro: $message'),
        duration: Duration(milliseconds: 4 * 1000),
        backgroundColor: Colors.red,
        behavior: behavior)
    );
  }

}