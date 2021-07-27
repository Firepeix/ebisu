import 'package:ebisu/card/Application/GetTypes/GetCardTypesCommand.dart';
import 'package:ebisu/card/Domain/Repositories/CardRepositoryInterface.dart';
import 'package:ebisu/card/Infrastructure/Repositories/CardRepository.dart';

class CardModuleServiceProvider {
  static CardRepositoryInterface cardRepository () => GoogleSheetCardRepository();

  static Map<String, Function>  getCommandMap () {
    return {
      (GetCardTypesCommand).toString(): () => new GetCardTypesCommandHandler()
    };
  }
}