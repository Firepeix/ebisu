import 'package:ebisu/card/Application/GetTypes/GetCardTypesCommand.dart';
import 'package:ebisu/card/Domain/Repositories/CardRepositoryInterface.dart';
import 'package:ebisu/card/Infrastructure/Repositories/CardRepository.dart';
import 'package:ebisu/shared/Domain/Bus/Command.dart';

class CardModuleServiceProvider {
  static CardRepositoryInterface cardRepository () => GoogleSheetCardRepository();
  static BusServiceProviderInterface getBusProvider () => CardModuleBusServiceProvider();
}

class CardModuleBusServiceProvider implements BusServiceProviderInterface{
  Map<String, Function>  getCommandMap () {
    return {
      (GetCardTypesCommand).toString(): () => new GetCardTypesCommandHandler()
    };
  }
}