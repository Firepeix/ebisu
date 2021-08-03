import 'package:ebisu/configuration/Domain/Repositories/ConfigurationRepositoryInterface.dart';
import 'package:ebisu/configuration/Infrastructure/Providers/ConfigurationModuleServiceProvider.dart';
import 'package:ebisu/shared/Domain/Bus/Command.dart';

class StoreSheetIdCommand implements Command {
  String sheetId;

  StoreSheetIdCommand({required this.sheetId});
}

class StoreSheetIdCommandHandler implements CommandHandler<StoreSheetIdCommand> {
  final ConfigurationRepositoryInterface _repository = ConfigurationModuleServiceProvider.repository;

  @override
  Future<void> handle(StoreSheetIdCommand command) async {
    await _repository.saveSheetId(command.sheetId);
  }
}