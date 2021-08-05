import 'package:ebisu/card/Domain/Repositories/CardRepositoryInterface.dart';
import 'package:ebisu/shared/Domain/Bus/Command.dart';
import 'package:injectable/injectable.dart';

class GetCardTypesCommand implements Command {

}

@injectable
class GetCardTypesCommandHandler implements CommandHandler<GetCardTypesCommand> {
  final CardRepositoryInterface _repository;
  GetCardTypesCommandHandler(this._repository);

  @override
  Future<Map<int, String>> handle(GetCardTypesCommand command) async {
    return await _repository.getCardTypes();
  }
}