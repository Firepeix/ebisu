import 'package:ebisu/expenditure/domain/mappers/purchase_mapper.dart';
import 'package:ebisu/expenditure/models/purchase/credit_expense_purchase_summary.dart';
import 'package:ebisu/shared/http/client.dart';
import 'package:injectable/injectable.dart';

class _Endpoint {
  static const PurchaseCreditSummary = "purchases/credit/summary";
}

abstract class PurchaseRepositoryInterface {
  Future<List<CreditExpensePurchaseSummaryModel>> getPurchaseCreditSummary();
}

@Injectable(as: PurchaseRepositoryInterface)
class PurchaseRepository implements PurchaseRepositoryInterface {
  final Caron _caron;
  final PurchaseMapper _mapper;
  PurchaseRepository(this._caron, this._mapper);

  @override
  Future<List<CreditExpensePurchaseSummaryModel>> getPurchaseCreditSummary() async {
    return await _caron.get(_Endpoint.PurchaseCreditSummary, _mapper.fromJsonList);
  }
}