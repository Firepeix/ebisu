import 'package:ebisu/modules/expense/core/domain/expense.dart';
import 'package:ebisu/shared/exceptions/result.dart';

abstract class ExpenseGateway {
  Future<AnyResult<List<Expense>>> getExpenses();
}