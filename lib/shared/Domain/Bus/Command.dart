import 'package:ebisu/card/Infrastructure/Providers/CardModuleServiceProvider.dart';
import 'package:ebisu/configuration/Infrastructure/Providers/ConfigurationModuleServiceProvider.dart';
import 'package:ebisu/expenditure/Infrastructure/Providers/ExpenditureModuleServiceProvider.dart';

class BusCommandServiceProvider {
  static final BusCommandServiceProvider _singleton = BusCommandServiceProvider._internal();
  final Map<String, Function> commands = {
    ...CardModuleServiceProvider.bus,
    ...ConfigurationModuleServiceProvider.bus,
    ...ExpenditureModuleServiceProvider.bus
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