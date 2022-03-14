import 'package:ebisu/shared/dependency/dependency_container.dart';
import 'package:flutter/material.dart';

class LoadingHandlerService {
  static void displayLoading ({String message = "Processando", behavior: SnackBarBehavior.fixed}) {
    final context = DependencyManager.getContext();
    if (context != null) {
      ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
      messenger.showSnackBar(SnackBar(
          content: Text(message),
          duration: Duration(seconds: 100),
          behavior: behavior
      ));
    }
  }

  static void displaySuccess ({String message = "Sucesso", behavior: SnackBarBehavior.fixed}) {
    final context = DependencyManager.getContext();
    if (context != null) {
      ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 4),
        behavior: behavior,)
      );
    }
  }
}