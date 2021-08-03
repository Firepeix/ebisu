import 'package:ebisu/configuration/Domain/Repositories/ConfigurationRepositoryInterface.dart';
import 'package:ebisu/configuration/Infrastructure/Providers/ConfigurationModuleServiceProvider.dart';
import 'package:ebisu/shared/Domain/Bus/Command.dart';

class GetSheetIdCommand implements Command {

}

class GetSheetIdCommandHandler implements CommandHandler<GetSheetIdCommand> {
  final ConfigurationRepositoryInterface _repository = ConfigurationModuleServiceProvider.repository;

  @override
  Future<String?> handle(GetSheetIdCommand command) async {
    return await _repository.getSheetId();
  }
}