
import 'package:ebisu/modules/expense/core/domain/expense.dart';
import 'package:ebisu/modules/expense/core/gateway/expense_gateway.dart';
import 'package:ebisu/shared/exceptions/result.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetExpensesUseCase {

  final ExpenseGateway _gateway;

  GetExpensesUseCase(this._gateway);

  Future<AnyResult<List<Expense>>> getExpenses() async {
    return await _gateway.getExpenses();
  }
}