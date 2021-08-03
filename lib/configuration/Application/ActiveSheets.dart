import 'package:ebisu/card/Domain/Card.dart';
import 'package:ebisu/configuration/Domain/Repositories/ConfigurationRepositoryInterface.dart';
import 'package:ebisu/configuration/Infrastructure/Providers/ConfigurationModuleServiceProvider.dart';
import 'package:ebisu/shared/Domain/Bus/Command.dart';

class GetActiveSheetNameCommand implements Command {
  final CardClass type;

  GetActiveSheetNameCommand({required this.type});
}

class GetActiveSheetNameCommandHandler implements CommandHandler<GetActiveSheetNameCommand> {
  final ConfigurationRepositoryInterface _repository = ConfigurationModuleServiceProvider.repository;

  @override
  Future<String?> handle(GetActiveSheetNameCommand command) async {
    return await _repository.getActiveSheetName(command.type);
  }
}

class StoreActiveSheetNameCommand implements Command {
  final String sheetName;
  final CardClass type;

  StoreActiveSheetNameCommand({required this.sheetName, required this.type});
}

class StoreActiveSheetNameCommandHandler implements CommandHandler<StoreActiveSheetNameCommand> {
  final ConfigurationRepositoryInterface _repository = ConfigurationModuleServiceProvider.repository;

  @override
  Future<void> handle(StoreActiveSheetNameCommand command) async {
    await _repository.saveActiveSheetName(command.sheetName, command.type);
  }
}