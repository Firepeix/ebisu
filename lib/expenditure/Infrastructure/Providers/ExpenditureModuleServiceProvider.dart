import 'package:ebisu/expenditure/Application/ExpenditureCommands.dart';
import 'package:ebisu/main.dart';
import 'package:ebisu/shared/Domain/Bus/Command.dart';

class ExpenditureModuleServiceProvider implements BusServiceProviderInterface {
  static Map<String, Function> bus = {
    (GetExpendituresCommand).toString(): () => getIt<GetExpendituresCommandHandler>(),
    (GetCreditExpendituresSummariesCommand).toString(): () => getIt<GetCreditExpendituresSummariesCommandHandler>(),
    (GetDebitExpenditureSummaryCommand).toString(): () => getIt<GetDebitExpenditureSummaryCommandHandler>()
  };
}
