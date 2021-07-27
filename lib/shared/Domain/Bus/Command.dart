import 'package:ebisu/card/Infrastructure/Providers/CardModuleServiceProvider.dart';

abstract class BusCommandServiceProvider {
  static Map<String, Function>  getCommandMap () {
    return CardModuleServiceProvider.getCommandMap();
  }
}

mixin DispatchesCommands {
  dynamic dispatch (Command command) {
    String key = command.runtimeType.toString();
    CommandHandler? handler = getHandler(key);
    if (handler != null) {
      return handler.handle(command);
    }
  }

  CommandHandler? getHandler (String command) {
    final handler = BusCommandServiceProvider.getCommandMap()[command.toString()];
    return handler!();
  }
}

abstract class Command {

}

abstract class CommandHandler <Command>{
  dynamic handle(Command command);
}