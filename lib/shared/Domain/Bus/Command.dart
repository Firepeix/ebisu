import 'package:ebisu/card/Infrastructure/Providers/CardModuleServiceProvider.dart';
import 'package:ebisu/configuration/Infrastructure/Providers/ConfigurationModuleServiceProvider.dart';

class BusCommandServiceProvider {
  static final BusCommandServiceProvider _singleton = BusCommandServiceProvider._internal();
  final List<BusServiceProviderInterface> providers = [
    CardModuleServiceProvider.getBusProvider(),
    ConfigurationModuleServiceProvider.getBusProvider()
  ];
  final Map<String, Function> commands = {};


  factory BusCommandServiceProvider() {
    return _singleton;
  }

  BusCommandServiceProvider._internal() {
    _setCommands();
  }

  void _setCommands () {
    providers.forEach((element) {
      commands.addAll(element.getCommandMap());
    });
  }
}

abstract class BusServiceProviderInterface {
  Map<String, Function> getCommandMap ();
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