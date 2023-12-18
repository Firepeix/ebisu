import 'package:ebisu/shared/exceptions/reporter.dart';
import 'package:ebisu/shared/exceptions/result.dart';
import 'package:ebisu/shared/exceptions/result_error.dart';
import 'package:ebisu/shared/services/notification_service.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
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

  void _displayError(ResultError error, {behavior =  SnackBarBehavior.fixed}) {
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

@override
V? handleError<V, E extends ResultError>(ResultError error, BuildContext context) {
  _reportError(error);
  _displayError(error, context);
  return null;
}

void _displayError(ResultError error, BuildContext context, {behavior = SnackBarBehavior.fixed}) {
  final message = error.intrisincs?.messageOverride ?? error.message;
  ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(SnackBar(
      content: Text(message ?? "Ocorreu um erro, por favor tente mais tarde!"),
      duration: Duration(seconds: 4),
      backgroundColor: Colors.red,
      behavior: behavior
  ));
}


void _reportError(ResultError error) {
  if (kDebugMode) {
    _printError(error);
  }

  if (!kDebugMode && error.details?.data != null && error.details?.data is FlutterErrorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(error.details!.data);
  }
}

void _printError(ResultError error) {
  // ignore: avoid_print
  print('======== TUTU DEU BUG =====================================================');
  final message =
      "${error.message ?? ''}${error.message != null && error.details?.messageAddon != null ? " " : ''}${error.details?.messageAddon ?? ''}";
  // ignore: avoid_print
  print('O seguinte erro foi pego: ${error.runtimeType} - $message - ${error.code}');

  if (error.intrisincs != null) {
    print("Intrisincs: ${error.intrisincs?.messageOverride}");
  }

  if (error.details?.data != null && error.details?.data is FlutterErrorDetails) {
    final details = error.details?.data as FlutterErrorDetails;

    // If available, give a reason to the exception.
    if (details.context != null) {
      // ignore: avoid_print
      print('The following exception was thrown ${details.context}:');
    }

    // Need to print the exception to explain why the exception was thrown.
    // ignore: avoid_print
    print(details.exceptionAsString());

    final information = details.informationCollector?.call() ?? [];

    // Print information provided by the Flutter framework about the exception.
    if (information.isNotEmpty) {
      // ignore: avoid_print
      print('\n$information');
    }

    // Not using Trace.format here to stick to the default stack trace format
    // that Flutter developers are used to seeing.
    // ignore: avoid_print
    if (details.stack != null) {
      // ignore: avoid_print
      print('\n${details.stack}');
    }
  }

  // ignore: avoid_print
  print(
      '====================================================================================================');
}