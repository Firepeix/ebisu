import 'package:ebisu/configuration/Domain/Repositories/ConfigurationRepositoryInterface.dart';
import 'package:ebisu/shared/Domain/Bus/Command.dart';
import 'package:injectable/injectable.dart';

class StoreSheetIdCommand implements Command {
  String sheetId;

  StoreSheetIdCommand({required this.sheetId});
}

@injectable
class StoreSheetIdCommandHandler implements CommandHandler<StoreSheetIdCommand> {
  final ConfigurationRepositoryInterface _repository;
  StoreSheetIdCommandHandler(this._repository);

  @override
  Future<void> handle(StoreSheetIdCommand command) async {
    await _repository.saveSheetId(command.sheetId);
  }
}