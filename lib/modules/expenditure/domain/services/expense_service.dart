import 'package:ebisu/modules/expenditure/domain/repositories/expense_repository.dart';
import 'package:ebisu/modules/expenditure/infrastructure/transfer_objects/creates_expense.dart';
import 'package:ebisu/modules/expenditure/models/expense/expenditure_model.dart';
import 'package:ebisu/shared/exceptions/handler.dart';
import 'package:ebisu/shared/exceptions/result.dart';
import 'package:ebisu/shared/services/notification_service.dart';
import 'package:injectable/injectable.dart';


abstract class ExpenseServiceInterface {
  Future<Result<void, ExpenseError>> createExpense(CreatesExpense builder);
  Future<List<ExpenseModel>> getCurrentExpenses();
  Future<Result<void, ResultError>> deleteExpense(ExpenseModel model);
}

@Injectable(as: ExpenseServiceInterface)
class ExpenseService implements ExpenseServiceInterface {
  final ExpenseRepositoryInterface _repository;
  final ExceptionHandlerInterface _exceptionHandler;
  final NotificationService _notificationService;

  ExpenseService(this._repository, this._exceptionHandler, this._notificationService);

  @override
  Future<Result<void, ExpenseError>> createExpense(CreatesExpense builder) async {
    _notificationService.displayLoading();
    final result = await _repository.insert(builder);

    if(result.isOk()) {
      _notificationService.displaySuccess(message: result.unwrap().message);
    }

    _exceptionHandler.expect(result);
    return result;
  }

  @override
  Future<List<ExpenseModel>> getCurrentExpenses() async {
    final result = await _repository.getCurrentExpenses();
    return _exceptionHandler.expect(result) ?? [];
  }

  @override
  Future<Result<void, ResultError>> deleteExpense(ExpenseModel model) async{
    final result = await _repository.deleteExpense(model.id);
    _exceptionHandler.expect(result);
    return result;
  }
}