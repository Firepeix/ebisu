import 'package:ebisu/modules/card/domain/mappers/card_mapper.dart';
import 'package:ebisu/modules/common/core/domain/money.dart';
import 'package:ebisu/modules/expenditure/models/purchase/credit_expense_purchase_summary.dart';
import 'package:injectable/injectable.dart';

@injectable
class PurchaseMapper {
  CardMapper _cardMapper;

  PurchaseMapper(this._cardMapper);

  CreditExpensePurchaseSummaryModel fromJson(Map<dynamic, dynamic> json) {
    return CreditExpensePurchaseSummaryModel(
        card: _cardMapper.fromJson(json["card"]),
        spent: Money(json["spent"]),
        planned: Money(json["planned"]),
        difference: Money(json["difference"]),
        previousInstallmentSpent: Money(json["previous_installment_spent"])
    );
  }

  List<CreditExpensePurchaseSummaryModel> fromJsonList(Map<dynamic, dynamic> json) {
    return (json["data"] as List<dynamic>).map((e) => fromJson(e)).toList();
  }
}