import 'package:ebisu/main.dart';
import 'package:ebisu/modules/expenditure/Application/ExpenditureCommands.dart';
import 'package:ebisu/shared/Domain/Bus/Command.dart';

class ExpenditureModuleServiceProvider implements BusServiceProviderInterface {
  static Map<String, Function> bus = {
    (GetDebitExpenditureSummaryCommand).toString(): () => getIt<GetDebitExpenditureSummaryCommandHandler>()
  };
}
