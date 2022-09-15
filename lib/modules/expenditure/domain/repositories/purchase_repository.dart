import 'package:ebisu/modules/expenditure/domain/mappers/purchase_mapper.dart';
import 'package:ebisu/modules/expenditure/models/purchase/credit_expense_purchase_summary.dart';
import 'package:ebisu/shared/exceptions/result.dart';
import 'package:ebisu/shared/http/client.dart';
import 'package:injectable/injectable.dart';

enum PurchaseError implements ResultError {
  GET_CREDIT_SUMMARY_ERROR("Não foi possível buscar sumario de despesas", "PCS1");

  final String message;
  final String code;
  final dynamic details;

  const PurchaseError(this.message, this.code, { this.details });
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
    return result.subError(PurchaseError.GET_CREDIT_SUMMARY_ERROR);
  }
}