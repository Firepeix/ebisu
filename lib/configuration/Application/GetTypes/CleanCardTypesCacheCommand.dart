import 'package:ebisu/configuration/Domain/Repositories/ConfigurationRepositoryInterface.dart';
import 'package:ebisu/configuration/Infrastructure/Providers/ConfigurationModuleServiceProvider.dart';
import 'package:ebisu/shared/Domain/Bus/Command.dart';

class CleanCardTypesCacheCommand implements Command {

}

class CleanCardTypesCacheCommandHandler implements CommandHandler<CleanCardTypesCacheCommand> {
  final ConfigurationRepositoryInterface _repository = ConfigurationModuleServiceProvider.repository;

  @override
  Future<void> handle(CleanCardTypesCacheCommand command) async {
    await _repository.cleanCardTypeCache();
  }
}