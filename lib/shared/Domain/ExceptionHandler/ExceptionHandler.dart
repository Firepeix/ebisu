import 'package:ebisu/main.dart';
import 'package:ebisu/shared/Domain/Services/ExpcetionHandlerService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

mixin DisplaysErrors {
  final ExceptionHandlerServiceInterface _service = getIt<ExceptionHandlerServiceInterface>();

  void displayError (Object error, {BuildContext? context}) {
    print(error);
    if (context != null) {
      _service.displayError(error.toString(), context, behavior: SnackBarBehavior.floating);
    }
  }
}