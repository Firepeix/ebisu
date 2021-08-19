import 'package:ebisu/main.dart';
import 'package:ebisu/shared/Domain/Services/ExpcetionHandlerService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

mixin DisplaysErrors {
  ExceptionHandlerServiceInterface _service = getIt<ExceptionHandlerServiceInterface>();

  void displayError (Object error, {BuildContext? context}) {
    print(error);
    if (context != null) {
      _showErrorSnackBar(error.toString(), context);
    }
  }

  void _showErrorSnackBar (String message, BuildContext context) {
    ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(SnackBar(
        content: Text('Erro: $message'),
        duration: Duration(milliseconds: 4 * 1000),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating)
    );
  }
}