import 'package:ebisu/configuration/Domain/Repositories/ConfigurationRepositoryInterface.dart';
import 'package:ebisu/configuration/Infrastructure/Providers/ConfigurationModuleServiceProvider.dart';
import 'package:ebisu/shared/Domain/Bus/Command.dart';

class CleanCredentialsCommand implements Command {

}

class CleanCredentialsCommandHandler implements CommandHandler<CleanCredentialsCommand> {
  final ConfigurationRepositoryInterface _repository = ConfigurationModuleServiceProvider.repository;

  @override
  Future<void> handle(CleanCredentialsCommand command) async {
    await _repository.cleanCredentials();
  }
}