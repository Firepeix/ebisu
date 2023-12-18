
import 'package:ebisu/modules/expense/core/domain/expense.dart';
import 'package:ebisu/modules/expense/core/gateway/expense_gateway.dart' as I;
import 'package:ebisu/modules/expense/dataprovider/client/api/mapper/expense_mapper.dart';
import 'package:ebisu/modules/expense/dataprovider/client/api/request/get_expenses_request.dart';
import 'package:ebisu/shared/exceptions/result.dart';
import 'package:ebisu/shared/http/client.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: I.ExpenseGateway)
class ExpenseGateway implements I.ExpenseGateway {
  final Caron _caron;

  ExpenseGateway(this._caron);

  @override
  Future<AnyResult<List<Expense>>> getExpenses() async {
    final request = GetExpensesRequest();
    final result = await _caron.get(request);
    return result.map((value) => value.map((e) => e.toExpense()).toList());
  }
}