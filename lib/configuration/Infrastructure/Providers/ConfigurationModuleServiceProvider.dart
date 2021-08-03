import 'package:ebisu/configuration/Application/ActiveSheets.dart';
import 'package:ebisu/configuration/Application/GetSheetId.dart';
import 'package:ebisu/configuration/Application/GetTypes/CleanCardTypesCacheCommand.dart';
import 'package:ebisu/configuration/Application/GetTypes/CleanCredentialsCommand.dart';
import 'package:ebisu/configuration/Application/StoreSheetId.dart';
import 'package:ebisu/configuration/Domain/Repositories/ConfigurationRepositoryInterface.dart';
import 'package:ebisu/configuration/Infrastructure/Persistence/ConfigurationRepository.dart';
import 'package:ebisu/shared/Domain/Bus/Command.dart';

class ConfigurationModuleServiceProvider {
  static final ConfigurationRepositoryInterface repository = ConfigurationRepository();
  static BusServiceProviderInterface getBusProvider () => ConfigurationModuleBusServiceProvider();
}

class ConfigurationModuleBusServiceProvider implements BusServiceProviderInterface{
  Map<String, Function>  getCommandMap () {
    return {
      (CleanCardTypesCacheCommand).toString(): () => new CleanCardTypesCacheCommandHandler(),
      (CleanCredentialsCommand).toString(): () => new CleanCredentialsCommandHandler(),
      (GetSheetIdCommand).toString(): () => new GetSheetIdCommandHandler(),
      (StoreSheetIdCommand).toString(): () => new StoreSheetIdCommandHandler(),
      (GetActiveSheetNameCommand).toString(): () => new GetActiveSheetNameCommandHandler(),
      (StoreActiveSheetNameCommand).toString(): () => new StoreActiveSheetNameCommandHandler(),
    };
  }
}