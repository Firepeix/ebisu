import 'package:ebisu/modules/expenditure/domain/mappers/expense_mapper.dart';
import 'package:ebisu/modules/expenditure/infrastructure/transfer_objects/creates_expense.dart';
import 'package:ebisu/modules/expenditure/models/expense/expenditure_model.dart';
import 'package:ebisu/shared/exceptions/result.dart';
import 'package:ebisu/shared/http/client.dart';
import 'package:ebisu/shared/http/codes.dart';
import 'package:ebisu/shared/http/response.dart';
import 'package:ebisu/shared/utils/matcher.dart';
import 'package:injectable/injectable.dart';

enum ExpenseError implements ResultError {
  GET_EXPENSES_ERROR("E1", message: "Não foi possível buscar despesas"),
  INVALID_DATA_SENT_TO_CREATE("E3", message: "Dados invalidos: "),
  NOT_FOUND_ERROR("E4"),
  CREATE_EXPENSE_ERROR("E5");

  final String message;
  final String code;

  const ExpenseError(this.code, {this.message = ""});
}

abstract class ExpenseRepositoryInterface {
  Future<Result<Success, ExpenseError>> insert(CreatesExpense expenditure);
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
  Future<Result<Success, ExpenseError>> insert(CreatesExpense expenditure) async {
    final result = await _caron.post<Success, CreatesExpense>(_Endpoint.ExpensesIndex, expenditure, _mapper.toJson, errorDecoder: _mapErrors);
    return result.mapErrorTo<ExpenseError>();
  }

  Result<Success, ExpenseError> _mapErrors(ErrorResponse response) {
    return Matcher.matchWhen(response.code, {
      HttpCodes.InternalError: Result(null, ExpenseError.CREATE_EXPENSE_ERROR, details: Details(messageAddon: response.message)),
      HttpCodes.NotFound: Result(null, ExpenseError.NOT_FOUND_ERROR, details: Details(messageAddon: response.message))
    }, base: Result(null, ExpenseError.CREATE_EXPENSE_ERROR, details: Details(messageAddon: response.message)));
  }
}