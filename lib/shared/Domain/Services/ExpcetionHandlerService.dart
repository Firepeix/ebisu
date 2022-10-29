import 'package:ebisu/shared/dependency/dependency_container.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

abstract class ExceptionHandlerServiceInterface {
  T? wrap<T>(Function callback);
  Future<T?> wrapAsync<T>(Function callback);
  void displayError(String message, BuildContext context, {behavior: SnackBarBehavior.fixed});
}

@Singleton(as: ExceptionHandlerServiceInterface)
class ExceptionHandlerService implements ExceptionHandlerServiceInterface {

  @override
  T? wrap<T>(Function callback) {
    try {
      return callback();
    } catch (error) {
      final context = DependencyManager.getContext();
      if (context != null) {
        FirebaseCrashlytics.instance.recordFlutterFatalError(FlutterErrorDetails(exception: error));
        displayError(error.toString(), context);
      } else {
        throw error;
      }
    }
  }

  @override
  Future<T?> wrapAsync<T>(Function callback) async {
    try {
      return await callback();
    } catch (error) {
      final context = DependencyManager.getContext();
      if (context != null) {
        FirebaseCrashlytics.instance.recordFlutterFatalError(FlutterErrorDetails(exception: error));
        displayError(error.toString(), context);
      } else {
        throw error;
      }
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