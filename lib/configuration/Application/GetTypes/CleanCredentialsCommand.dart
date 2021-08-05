import 'package:ebisu/configuration/Domain/Repositories/ConfigurationRepositoryInterface.dart';
import 'package:ebisu/shared/Domain/Bus/Command.dart';
import 'package:injectable/injectable.dart';

class CleanCredentialsCommand implements Command {

}

@injectable
class CleanCredentialsCommandHandler implements CommandHandler<CleanCredentialsCommand> {
  final ConfigurationRepositoryInterface _repository;
  CleanCredentialsCommandHandler(this._repository);

  @override
  Future<void> handle(CleanCredentialsCommand command) async {
    await _repository.cleanCredentials();
  }
}