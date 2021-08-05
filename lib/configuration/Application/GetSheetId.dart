import 'package:ebisu/configuration/Domain/Repositories/ConfigurationRepositoryInterface.dart';
import 'package:ebisu/shared/Domain/Bus/Command.dart';
import 'package:injectable/injectable.dart';

class GetSheetIdCommand implements Command {

}

@injectable
class GetSheetIdCommandHandler implements CommandHandler<GetSheetIdCommand> {
  final ConfigurationRepositoryInterface _repository;
  GetSheetIdCommandHandler(this._repository);

  @override
  Future<String?> handle(GetSheetIdCommand command) async {
    return await _repository.getSheetId();
  }
}