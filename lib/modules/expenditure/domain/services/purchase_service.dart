import 'package:ebisu/modules/expenditure/domain/repositories/purchase_repository.dart';
import 'package:ebisu/modules/expenditure/models/purchase/credit_expense_purchase_summary.dart';
import 'package:ebisu/shared/exceptions/handler.dart';
import 'package:injectable/injectable.dart';

abstract class ExpensePurchaseServiceInterface {
  Future<List<CreditExpensePurchaseSummaryModel>> getPurchaseCreditSummary();
  Future<int> getLocalCreditSummaryQuantity();
}

@Injectable(as: ExpensePurchaseServiceInterface)
class ExpensePurchaseService implements ExpensePurchaseServiceInterface {
  final PurchaseRepositoryInterface _repository;
  final ExceptionHandlerInterface _exceptionHandler;

  ExpensePurchaseService(this._repository, this._exceptionHandler);

  @override
  Future<List<CreditExpensePurchaseSummaryModel>> getPurchaseCreditSummary() async {
    final result = await _repository.getPurchaseCreditSummary();
    result.willMatch(ok: (value) async => await _repository.setLocalCreditSummaryQuantity(value.length));
    return _exceptionHandler.expect(result) ?? [];
  }

  @override
  Future<int> getLocalCreditSummaryQuantity() async {
    return await _repository.getLocalCreditSummaryQuantity();
  }


}