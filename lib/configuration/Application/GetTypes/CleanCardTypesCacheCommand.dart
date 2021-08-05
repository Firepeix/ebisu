import 'package:ebisu/configuration/Domain/Repositories/ConfigurationRepositoryInterface.dart';
import 'package:ebisu/shared/Domain/Bus/Command.dart';
import 'package:injectable/injectable.dart';

class CleanCardTypesCacheCommand implements Command {

}

@injectable
class CleanCardTypesCacheCommandHandler implements CommandHandler<CleanCardTypesCacheCommand> {
  final ConfigurationRepositoryInterface _repository;

  CleanCardTypesCacheCommandHandler(this._repository);

  @override
  Future<void> handle(CleanCardTypesCacheCommand command) async {
    await _repository.cleanCardTypeCache();
  }
}