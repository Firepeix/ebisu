import 'package:ebisu/expenditure/domain/Expenditure.dart';
import 'package:ebisu/expenditure/domain/ExpenditureSummary.dart';
import 'package:ebisu/expenditure/domain/repositories/ExpenditureRepositoryInterface.dart';
import 'package:ebisu/shared/Domain/Bus/Command.dart';
import 'package:injectable/injectable.dart';

class GetExpendituresCommand implements Command {
  final bool cacheLess;

  GetExpendituresCommand(this.cacheLess);

}

@injectable
class GetExpendituresCommandHandler implements CommandHandler<GetExpendituresCommand> {
  final ExpenditureRepositoryInterface _repository;
  GetExpendituresCommandHandler(this._repository);

  @override
  Future<List<Expenditure>> handle(GetExpendituresCommand command) async {
    return await _repository.getExpenditures(command.cacheLess);
  }
}

class GetCreditExpendituresSummariesCommand implements Command {
  final bool cacheLess;

  GetCreditExpendituresSummariesCommand(this.cacheLess);
}

@injectable
class GetCreditExpendituresSummariesCommandHandler implements CommandHandler<GetCreditExpendituresSummariesCommand> {
  final ExpenditureRepositoryInterface _repository;
  GetCreditExpendituresSummariesCommandHandler(this._repository);

  @override
  Future<List<ExpenditureSummary>> handle(GetCreditExpendituresSummariesCommand command) async {
    return await _repository.getCreditExpenditureSummaries(command.cacheLess);
  }
}

class GetDebitExpenditureSummaryCommand implements Command {
  final bool cacheLess;

  GetDebitExpenditureSummaryCommand(this.cacheLess);

}

@injectable
class GetDebitExpenditureSummaryCommandHandler implements CommandHandler<GetDebitExpenditureSummaryCommand> {
  final ExpenditureRepositoryInterface _repository;
  GetDebitExpenditureSummaryCommandHandler(this._repository);

  @override
  Future<DebitExpenditureSummary?> handle(GetDebitExpenditureSummaryCommand command) async {
    return await _repository.getDebitExpenditureSummary(command.cacheLess);
  }
}