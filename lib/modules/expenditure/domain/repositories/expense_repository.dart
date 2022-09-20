import 'package:ebisu/modules/expenditure/domain/mappers/expense_mapper.dart';
import 'package:ebisu/modules/expenditure/infrastructure/transfer_objects/creates_expense.dart';
import 'package:ebisu/modules/expenditure/models/expense/expenditure_model.dart';
import 'package:ebisu/shared/exceptions/result.dart';
import 'package:ebisu/shared/http/client.dart';
import 'package:ebisu/shared/http/codes.dart';
import 'package:ebisu/shared/http/response.dart';
import 'package:ebisu/shared/utils/matcher.dart';
import 'package:injectable/injectable.dart';

class ExpenseError extends ResultError {
  const ExpenseError.getExpenses() : super("Não foi possível buscar despesas", "E1", null);
  const ExpenseError.invalidData(Details details) : super("Dados invalidos: ", "E2", null);
  const ExpenseError.notFound(Details details) : super(null, "E3", details) ;
  const ExpenseError.createExpense(Details details) : super(null, "E4", details) ;
}

abstract class ExpenseRepositoryInterface {
  Future<Result<Success, ExpenseError>> insert(CreatesExpense expenditure);
  Future<Result<List<ExpenseModel>, ExpenseError>> getCurrentExpenses();
  Future<Result<void, ResultError>> deleteExpense(String id);
  Future<Result<ExpenseModel, ResultError>> getExpense(String id);

//Future<DebitExpenditureSummary> getDebitExpenditureSummary (bool cacheLess);
}

class _Endpoint {
  static const ExpensesIndex = "expenses";
  static const Expense = "expenses/:expenseId";
}

@Injectable(as: ExpenseRepositoryInterface)
class ExpenseRepository implements ExpenseRepositoryInterface {
  final Caron _caron;
  final ExpenseMapper _mapper;
  ExpenseRepository(this._caron, this._mapper);

  @override
  Future<Result<List<ExpenseModel>, ExpenseError>> getCurrentExpenses() async {
    final result = await _caron.getList<ExpenseModel>(_Endpoint.ExpensesIndex, _mapper.fromJson);
    return result.map((value) => value.data).subError(ExpenseError.getExpenses());
  }

  @override
  Future<Result<Success, ExpenseError>> insert(CreatesExpense expenditure) async {
   final result = await _caron.post<Success, CreatesExpense>(_Endpoint.ExpensesIndex, expenditure, _mapper.toJson, errorDecoder: _mapErrors);
   return result.mapErrorTo<ExpenseError>();
  }

  ExpenseError _mapErrors(ErrorResponse response) {
    return Matcher.matchWhen(response.code, {
      HttpCodes.InternalError: ExpenseError.createExpense(Details(messageAddon: response.message)),
      HttpCodes.NotFound: ExpenseError.notFound(Details(messageAddon: response.message))
    }, base: ExpenseError.createExpense(Details(messageAddon: response.message)));
  }

  @override
  Future<Result<void, ResultError>> deleteExpense(String id) async {
    return await _caron.delete(_Endpoint.Expense.replaceAll(":expenseId", id));
  }

  @override
  Future<Result<ExpenseModel, ResultError>> getExpense(String id) async {
    final result = await _caron.get<ExpenseModel>(_Endpoint.Expense.replaceAll(":expenseId", id), _mapper.fromJson);
    return result.map((value) => value.data);
  }
}