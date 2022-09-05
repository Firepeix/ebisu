import 'package:ebisu/expenditure/domain/repositories/purchase_repository.dart';
import 'package:ebisu/expenditure/models/purchase/credit_expense_purchase_summary.dart';
import 'package:ebisu/shared/Domain/Services/ExpcetionHandlerService.dart';
import 'package:injectable/injectable.dart';

abstract class ExpensePurchaseServiceInterface {
  Future<List<CreditExpensePurchaseSummaryModel>> getPurchaseCreditSummary();
}

@Injectable(as: ExpensePurchaseServiceInterface)
class ExpensePurchaseService implements ExpensePurchaseServiceInterface {
  final PurchaseRepositoryInterface _repository;
  final ExceptionHandlerServiceInterface _exceptionHandler;

  ExpensePurchaseService(this._repository, this._exceptionHandler);

  @override
  Future<List<CreditExpensePurchaseSummaryModel>> getPurchaseCreditSummary() async {
    return await _exceptionHandler.wrapAsync(() async => await _repository.getPurchaseCreditSummary());
  }
}