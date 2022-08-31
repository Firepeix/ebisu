import 'package:ebisu/expenditure/models/purchase/credit_expense_purchase_summary.dart';
import 'package:injectable/injectable.dart';

abstract class PurchaseRepositoryInterface {
  Future<List<CreditExpensePurchaseSummaryModel>> getPurchaseCreditSummary();
}

@Injectable(as: PurchaseRepositoryInterface)
class PurchaseRepository implements PurchaseRepositoryInterface {
  @override
  Future<List<CreditExpensePurchaseSummaryModel>> getPurchaseCreditSummary() {
    // TODO: implement getPurchaseCreditSummary
    throw UnimplementedError();
  }
}