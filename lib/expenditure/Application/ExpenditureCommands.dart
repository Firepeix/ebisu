import 'package:ebisu/expenditure/domain/ExpenditureSummary.dart';
import 'package:ebisu/shared/Domain/Bus/Command.dart';
import 'package:injectable/injectable.dart';

class GetDebitExpenditureSummaryCommand implements Command {
  final bool cacheLess;

  GetDebitExpenditureSummaryCommand(this.cacheLess);

}

@injectable
class GetDebitExpenditureSummaryCommandHandler implements CommandHandler<GetDebitExpenditureSummaryCommand> {
  GetDebitExpenditureSummaryCommandHandler();

  @override
  Future<DebitExpenditureSummary?> handle(GetDebitExpenditureSummaryCommand command) async {
    return null;
  }
}