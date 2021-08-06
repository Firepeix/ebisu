import 'package:ebisu/expenditure/Domain/Expenditure.dart';
import 'package:ebisu/expenditure/Domain/Repositories/ExpenditureRepositoryInterface.dart';
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
    return _repository.getExpenditures(command.cacheLess);
  }
}