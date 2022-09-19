import 'package:ebisu/configuration/Application/GetSheetId.dart';
import 'package:ebisu/configuration/Application/GetTypes/CleanCredentialsCommand.dart';
import 'package:ebisu/configuration/Application/StoreSheetId.dart';
import 'package:ebisu/configuration/Domain/Repositories/ConfigurationRepositoryInterface.dart';
import 'package:ebisu/configuration/Infrastructure/Persistence/ConfigurationRepository.dart';
import 'package:ebisu/main.dart';
import 'package:ebisu/shared/Domain/Bus/Command.dart';

class ConfigurationModuleServiceProvider implements BusServiceProviderInterface {
  static final ConfigurationRepositoryInterface repository = ConfigurationRepository();

  static Map<String, Function> bus = {
    (CleanCredentialsCommand).toString(): () => getIt<CleanCredentialsCommandHandler>(),
    (GetSheetIdCommand).toString(): () => getIt<GetSheetIdCommandHandler>(),
    (StoreSheetIdCommand).toString(): () => getIt<StoreSheetIdCommandHandler>(),
  };
}
