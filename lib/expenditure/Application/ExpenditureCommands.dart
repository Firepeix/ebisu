import 'package:ebisu/expenditure/Domain/Repositories/ExpenditureRepositoryInterface.dart';
import 'package:ebisu/shared/Domain/Bus/Command.dart';
import 'package:injectable/injectable.dart';

class GetExpendituresCommand implements Command {

}

@injectable
class GetExpendituresCommandHandler implements CommandHandler<GetExpendituresCommand> {
  final ExpenditureRepositoryInterface _repository;
  GetExpendituresCommandHandler(this._repository);

  @override
  Future<List<int>> handle(GetExpendituresCommand command) async {
    _repository.getExpenditures();
    return [1];
  }
}