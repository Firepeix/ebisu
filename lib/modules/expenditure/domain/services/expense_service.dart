import 'package:ebisu/modules/expenditure/domain/repositories/expense_repository.dart';
import 'package:ebisu/modules/expenditure/models/expense/expenditure_model.dart';
import 'package:ebisu/shared/exceptions/handler.dart';
import 'package:injectable/injectable.dart';


abstract class ExpenseServiceInterface {
  ExpenseModel? createExpenditure(ExpenditureBuilder builder);
  Future<List<ExpenseModel>> getCurrentExpenses();
}

abstract class ExpenditureBuilder {
  String get name;
  int  get type;
  int  get amount;
  String? get cardType;
  int? get expenditureType;
  int? get currentInstallment;
  int? get installmentTotal;
}

@Injectable(as: ExpenseServiceInterface)
class ExpenseService implements ExpenseServiceInterface {
  final ExpenseRepositoryInterface _repository;
  final ExceptionHandlerInterface _exceptionHandler;

  ExpenseService(this._repository, this._exceptionHandler);

  @override
  ExpenseModel? createExpenditure(ExpenditureBuilder builder) {
    return null;
  }

  @override
  Future<List<ExpenseModel>> getCurrentExpenses() async {
    final result = await _repository.getCurrentExpenses();
    return _exceptionHandler.expect(result) ?? [];
  }
}