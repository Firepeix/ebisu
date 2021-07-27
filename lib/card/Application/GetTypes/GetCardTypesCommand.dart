import 'package:ebisu/card/Domain/Repositories/CardRepositoryInterface.dart';
import 'package:ebisu/card/Infrastructure/Providers/CardModuleServiceProvider.dart';
import 'package:ebisu/shared/Domain/Bus/Command.dart';

class GetCardTypesCommand implements Command {

}

class GetCardTypesCommandHandler implements CommandHandler<GetCardTypesCommand> {
  final CardRepositoryInterface _repository = CardModuleServiceProvider.cardRepository();

  @override
  Future<Map<int, String>> handle(GetCardTypesCommand command) async {
    return await _repository.getCardTypes();
  }

}