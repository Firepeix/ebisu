import 'package:ebisu/card/Application/GetTypes/GetCardTypesCommand.dart';
import 'package:ebisu/card/Domain/Repositories/CardRepositoryInterface.dart';
import 'package:ebisu/card/Infrastructure/Repositories/CardRepository.dart';
import 'package:ebisu/main.dart';
import 'package:ebisu/shared/Domain/Bus/Command.dart';

class CardModuleServiceProvider implements BusServiceProviderInterface {
  static CardRepositoryInterface cardRepository () => GoogleSheetCardRepository();
  static Map<String, Function> bus = {
    (GetCardTypesCommand).toString(): () => getIt<GetCardTypesCommandHandler>()
  };
}
