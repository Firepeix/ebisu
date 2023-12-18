import 'package:ebisu/shared/navigator/navigator_interface.dart';
import 'package:ebisu/ui_components/chronos/dialogs/confirm_dialog.dart';
import 'package:ebisu/ui_components/chronos/dialogs/select_dialog.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

enum ConfirmResult {
  confirmed,
  cancelled
}


@singleton
class NotificationService {
  final NavigatorService _contextService;

  NotificationService(this._contextService);

  void displayLoading ({BuildContext? context, String message = "Processando", behavior =  SnackBarBehavior.fixed}) {
    context = context ?? _contextService.getContext();
    if (context != null) {
      ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
      messenger.showSnackBar(SnackBar(
          content: Text(message),
          duration: Duration(seconds: 100),
          behavior: behavior
      ));
    }
  }

  void displaySuccess ({BuildContext? context, String message = "Sucesso", behavior =  SnackBarBehavior.fixed}) {
    context = context ?? _contextService.getContext();
    if (context != null) {
      ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
        behavior: behavior,)
      );
    }
  }

  void displayError ({BuildContext? context, String message = "Erro", behavior =  SnackBarBehavior.fixed}) {
    context = context ?? _contextService.getContext();
    if (context != null) {
      ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(SnackBar(
          content: Text(message),
          duration: Duration(seconds: 4),
          backgroundColor: Colors.red,
          behavior: behavior
      ));
    }
  }

  Future<ConfirmResult> displayConfirmation({BuildContext? context}) async {
    context = context ?? _contextService.getContext();
    if (context != null) {
      final result = await showModalBottomSheet(context: context, builder: (_) => ConfirmDialog());
      return result ?? ConfirmResult.cancelled;
    }

    return ConfirmResult.cancelled;
  }

  Future<T?> displaySelectDialog<T>(String title, List<SelectOption> options, {String? appendix, BuildContext? context}) async {
    context = context ?? _contextService.getContext();
    if (context != null) {
      return showSelectDialog(title: title, options: options, context: context, appendix: appendix);
    }

    return null;
  }
}

Future<T?> showSelectDialog<T>({required BuildContext context, required String title, required List<SelectOption> options, String? appendix }) async {
  return await showModalBottomSheet(context: context, builder: (_) => SelectDialog(title, options, appendix: appendix,));
}