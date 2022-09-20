import 'package:ebisu/shared/exceptions/result.dart';
import 'package:ebisu/shared/services/notification_service.dart';
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
  final NotificationService _notificationService;

  ExceptionHandler(this._notificationService);

  void _displayError (ResultError error, {behavior: SnackBarBehavior.fixed}) {
      _notificationService.displayError(message: "${error.message ?? ""}${error.details?.messageAddon ?? ""}");
  }

  @override
  V? expect<V, E extends ResultError>(Result<V, E> result) {
    if (result.hasError()) {
      _displayError(result.error!);
      return null;
    }

    return result.unwrap();
  }
}