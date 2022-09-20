import 'package:ebisu/modules/establishment/domain/services/establishment_service.dart';
import 'package:ebisu/modules/expenditure/domain/expense_source.dart';
import 'package:ebisu/modules/expenditure/domain/repositories/expense_repository.dart';
import 'package:ebisu/modules/expenditure/infrastructure/transfer_objects/creates_expense.dart';
import 'package:ebisu/modules/expenditure/models/expense/expenditure_model.dart';
import 'package:ebisu/modules/user/domain/services/user_service.dart';
import 'package:ebisu/shared/exceptions/handler.dart';
import 'package:ebisu/shared/exceptions/result.dart';
import 'package:ebisu/shared/services/notification_service.dart';
import 'package:injectable/injectable.dart';


abstract class ExpenseServiceInterface {
  Future<Result<void, ExpenseError>> createExpense(CreatesExpense builder);
  Future<List<ExpenseModel>> getCurrentExpenses();
  Future<Result<void, ResultError>> deleteExpense(ExpenseModel model);
  Future<List<ExpenseSourceModel>> getSources();
  Future<Result<ExpenseModel, ResultError>> getExpense(String id);
}

@Injectable(as: ExpenseServiceInterface)
class ExpenseService implements ExpenseServiceInterface {
  final ExpenseRepositoryInterface _repository;
  final ExceptionHandlerInterface _exceptionHandler;
  final NotificationService _notificationService;
  final UserServiceInterface _userServiceInterface;
  final EstablishmentServiceInterface _establishmentServiceInterface;

  ExpenseService(this._repository, this._exceptionHandler, this._notificationService, this._userServiceInterface, this._establishmentServiceInterface);

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

  @override
  Future<List<ExpenseSourceModel>> getSources() async {
    final responses = await Future.wait([
      _userServiceInterface.getFriends(),
      _establishmentServiceInterface.getEstablishments()
    ]);

    return [...responses[0], ...responses[1]];
  }

  @override
  Future<Result<ExpenseModel, ResultError>> getExpense(String id) async {
    final result = await _repository.getExpense(id);
    _exceptionHandler.expect(result);
    return result;
  }
}