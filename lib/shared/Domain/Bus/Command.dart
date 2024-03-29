import 'dart:async';

import 'package:ebisu/configuration/Infrastructure/Providers/ConfigurationModuleServiceProvider.dart';
import 'package:ebisu/shopping-list/Purchase/Infrastructure/Providers/ServicesProvider.dart';
import 'package:ebisu/shopping-list/ShoppingList/Infrastructure/Providers/ServicesProvider.dart';
import 'package:flutter/material.dart';

class BusCommandServiceProvider {
  static final BusCommandServiceProvider _singleton = BusCommandServiceProvider._internal();
  final Map<String, Function> commands = {
    ...ConfigurationModuleServiceProvider.bus,
    ...ShoppingListBindServiceProvider.bus,
    ...PurchaseBindServiceProvider.bus
  };


  factory BusCommandServiceProvider() {
    return _singleton;
  }

  BusCommandServiceProvider._internal();
}

abstract class BusServiceProviderInterface {
  static Map<String, Function> bus = {};
}

mixin DispatchesCommands {
  final BusCommandServiceProvider _provider = BusCommandServiceProvider();


  dynamic dispatch (Command command) {
    String key = command.runtimeType.toString();
    CommandHandler? handler = getHandler(key);
    if (handler != null) {
      return handler.handle(command);
    }
  }

  void showLoading(BuildContext context, {String message: 'Processando'}) {
    ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(SnackBar(content: Text(message), behavior: SnackBarBehavior.floating, duration: Duration(milliseconds: 30 * 1000)));
  }

  void showSuccess(BuildContext context, {String message: '', Function? onClose}) {
    ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    final displayFor = Duration(seconds: 2);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(SnackBar(
      content: Text("Sucesso: $message"),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
      duration: displayFor,
    ));
    if (onClose != null) {
      Timer(displayFor, () => onClose());
    }
  }

  void stopLoading(BuildContext context) {
    ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
  }

  CommandHandler? getHandler (String command) {
    final handler = _provider.commands[command.toString()];
    return handler!();
  }
}

abstract class Command {

}

abstract class CommandHandler <Command>{
  dynamic handle(Command command);
}