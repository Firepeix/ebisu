import 'package:ebisu/shared/exceptions/reporter.dart';
import 'package:ebisu/shared/exceptions/result.dart';
import 'package:ebisu/shared/exceptions/result_error.dart';
import 'package:ebisu/shared/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

abstract class ExceptionHandlerInterface {
  V? expect<V, E extends ResultError>(Result<V, E> result);
  ResultError createError(Error error, {StackTrace? alternativeStackTrace, String? errorContext});
  UnknownError createUnknownError(Object error, {StackTrace? alternativeStackTrace, String? errorContext});
  ResultError parseError(Object error, {StackTrace? alternativeStackTrace, String? errorContext});
}

@Singleton(as: ExceptionHandlerInterface)
class ExceptionHandler implements ExceptionHandlerInterface {
  final NotificationService _notificationService;
  final ReporterServiceInterface _reporterService;

  ExceptionHandler(this._notificationService, this._reporterService);

  void _displayError(ResultError error, {behavior: SnackBarBehavior.fixed}) {
    final message = error.intrisincs?.messageOverride ?? error.message;
    _notificationService.displayError(message: "${message ?? ""}${error.details?.messageAddon ?? ""}");
  }

  @override
  V? expect<V, E extends ResultError>(Result<V, E> result) {
    return result.match(
        err: (error) {
          _reporterService.reportError(error);
          _displayError(error);
          return null;
        },
        ok: (value) => value);
  }

  @override
  ResultError createError(Error error, {StackTrace? alternativeStackTrace, String? errorContext}) {
    return UnknownError(Details(
        data: FlutterErrorDetails(
            exception: error,
            stack: error.stackTrace ?? alternativeStackTrace,
            library: "Ebisu",
            context: errorContext != null ? ErrorDescription(errorContext) : null)));
  }

  @override
  UnknownError createUnknownError(Object error, {StackTrace? alternativeStackTrace, String? errorContext}) {
    return UnknownError(Details(
        data: FlutterErrorDetails(
            exception: error,
            stack: alternativeStackTrace,
            context: errorContext != null ? ErrorDescription(errorContext) : null)));
  }

  @override
  ResultError parseError(Object error, {StackTrace? alternativeStackTrace, String? errorContext}) {
    if (error is Error) {
      return createError(error, alternativeStackTrace: alternativeStackTrace, errorContext: errorContext);
    }

    return createUnknownError(error,
        alternativeStackTrace: alternativeStackTrace, errorContext: errorContext);
  }
}
