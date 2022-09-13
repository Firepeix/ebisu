import 'package:ebisu/modules/expenditure/domain/mappers/expense_mapper.dart';
import 'package:ebisu/modules/expenditure/infrastructure/transfer_objects/creates_expense.dart';
import 'package:ebisu/modules/expenditure/models/expense/expenditure_model.dart';
import 'package:ebisu/shared/exceptions/result.dart';
import 'package:ebisu/shared/http/client.dart';
import 'package:injectable/injectable.dart';

enum ExpenseError implements ResultError {
  GET_EXPENSES_ERROR("Não foi possível buscar despesas", 2);

  final String message;
  final int code;
  final dynamic details;

  const ExpenseError(this.message, this.code, { this.details });
}

abstract class ExpenseRepositoryInterface {
  Future<void> insert(CreatesExpense expenditure);
  Future<Result<List<ExpenseModel>, ExpenseError>> getCurrentExpenses();
  //Future<DebitExpenditureSummary> getDebitExpenditureSummary (bool cacheLess);
}

class _Endpoint {
  static const ExpensesIndex = "expenses";
}

@Injectable(as: ExpenseRepositoryInterface)
class ExpenseRepository implements ExpenseRepositoryInterface {
  final Caron _caron;
  final ExpenseMapper _mapper;
  ExpenseRepository(this._caron, this._mapper);

  @override
  Future<Result<List<ExpenseModel>, ExpenseError>> getCurrentExpenses() async {
    final result = await _caron.get(_Endpoint.ExpensesIndex, _mapper.fromJsonList);
    return result.subError(ExpenseError.GET_EXPENSES_ERROR);
  }

  @override
  Future<void> insert(CreatesExpense expenditure) {
    throw UnimplementedError();
  }
}