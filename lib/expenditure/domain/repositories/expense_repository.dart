import 'package:ebisu/expenditure/domain/mappers/expense_mapper.dart';
import 'package:ebisu/expenditure/infrastructure/transfer_objects/creates_expense.dart';
import 'package:ebisu/expenditure/models/expense/expenditure_model.dart';
import 'package:ebisu/shared/http/client.dart';
import 'package:injectable/injectable.dart';

abstract class ExpenseRepositoryInterface {
  Future<void> insert(CreatesExpense expenditure);
  Future<List<ExpenseModel>> getCurrentExpenses();
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
  Future<List<ExpenseModel>> getCurrentExpenses() async {
    return await _caron.get(_Endpoint.ExpensesIndex, _mapper.fromJsonList);
  }

  @override
  Future<void> insert(CreatesExpense expenditure) {
    throw UnimplementedError();
  }
}