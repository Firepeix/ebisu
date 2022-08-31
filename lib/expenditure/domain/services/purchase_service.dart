import 'package:ebisu/expenditure/domain/repositories/purchase_repository.dart';
import 'package:ebisu/expenditure/models/purchase/credit_expense_purchase_summary.dart';
import 'package:ebisu/shared/Domain/Services/ExpcetionHandlerService.dart';
import 'package:injectable/injectable.dart';

abstract class PurchaseServiceInterface {
  Future<List<CreditExpensePurchaseSummaryModel>> getPurchaseCreditSummary();
}

@Injectable(as: PurchaseServiceInterface)
class PurchaseService implements PurchaseServiceInterface {
  final PurchaseRepositoryInterface _repository;
  final ExceptionHandlerServiceInterface _exceptionHandler;

  PurchaseService(this._repository, this._exceptionHandler);

  @override
  Future<List<CreditExpensePurchaseSummaryModel>> getPurchaseCreditSummary() async {
    return await _exceptionHandler.wrapAsync(() async => await _repository.getPurchaseCreditSummary());
  }
}