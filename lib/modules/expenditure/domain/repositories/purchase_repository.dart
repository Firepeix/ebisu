import 'package:ebisu/modules/expenditure/domain/mappers/purchase_mapper.dart';
import 'package:ebisu/modules/expenditure/models/purchase/credit_expense_purchase_summary.dart';
import 'package:ebisu/shared/exceptions/result.dart';
import 'package:ebisu/shared/http/client.dart';
import 'package:injectable/injectable.dart';

class PurchaseError extends ResultError {
  const PurchaseError.getCreditSummary() : super("Não foi possível buscar sumario de despesas", "PCS1", null);
}

class _Endpoint {
  static const PurchaseCreditSummary = "purchases/credit/summary";
}

abstract class PurchaseRepositoryInterface {
  Future<Result<List<CreditExpensePurchaseSummaryModel>, PurchaseError>> getPurchaseCreditSummary();
}

@Injectable(as: PurchaseRepositoryInterface)
class PurchaseRepository implements PurchaseRepositoryInterface {
  final Caron _caron;
  final PurchaseMapper _mapper;
  PurchaseRepository(this._caron, this._mapper);

  @override
  Future<Result<List<CreditExpensePurchaseSummaryModel>, PurchaseError>> getPurchaseCreditSummary() async {
    final result = await _caron.get(_Endpoint.PurchaseCreditSummary, _mapper.fromJsonList);
    return result.subError(PurchaseError.getCreditSummary());
  }
}