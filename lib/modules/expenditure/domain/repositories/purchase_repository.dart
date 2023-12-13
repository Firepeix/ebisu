import 'package:ebisu/modules/expenditure/domain/mappers/purchase_mapper.dart';
import 'package:ebisu/modules/expenditure/models/purchase/credit_expense_purchase_summary.dart';
import 'package:ebisu/modules/purchases/debit/core/domain/debit_summary.dart';
import 'package:ebisu/modules/purchases/debit/dataprovider/client/api/mapper/purchases/debit_mapper.dart';
import 'package:ebisu/modules/purchases/debit/dataprovider/client/api/request/purchases/debit/get_debit_summary_request.dart';
import 'package:ebisu/shared/exceptions/result.dart';
import 'package:ebisu/shared/exceptions/result_error.dart';
import 'package:ebisu/shared/http/client.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _Endpoint {
  static const PurchaseCreditSummary = "purchases/credit/summary";
}

class PurchaseEndpoints {
  static const PurchaseCreditSummary = "purchases/credit/summary";
  static const PurchaseDebitSummary = "purchases/debit/summary";
}

class _CachedKeys {
  static const CreditSummaryQuantity = "purchases/credit/summary/quantity";
}

abstract class PurchaseRepositoryInterface {
  Future<Result<List<CreditExpensePurchaseSummaryModel>, ResultError>> getPurchaseCreditSummary();
  Future<Result<DebitSummary, ResultError>> getDebitSummary();
  Future<int> getLocalCreditSummaryQuantity();
  Future<void> setLocalCreditSummaryQuantity(int quantity);
}

@Injectable(as: PurchaseRepositoryInterface)
class PurchaseRepository implements PurchaseRepositoryInterface {
  final Caron _caron;
  final PurchaseMapper _mapper;
  PurchaseRepository(this._caron, this._mapper);

  @override
  Future<Result<List<CreditExpensePurchaseSummaryModel>, ResultError>> getPurchaseCreditSummary() async {
    final result = await _caron.getList<CreditExpensePurchaseSummaryModel>(_Endpoint.PurchaseCreditSummary, _mapper.fromJson);
    return result.map((value) => value.data);
  }

  @override
  Future<int> getLocalCreditSummaryQuantity() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_CachedKeys.CreditSummaryQuantity) ?? 4;
  }

  @override
  Future<void> setLocalCreditSummaryQuantity(int quantity) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(_CachedKeys.CreditSummaryQuantity, quantity);
  }

  @override
  Future<Result<DebitSummary, ResultError>> getDebitSummary() async {
    final request = GetDebitSummaryRequest();
    final result = await _caron.get(request);
    return result.map((value) => value.toDebitSummary());
  }
}