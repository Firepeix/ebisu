import 'package:ebisu/modules/expenditure/domain/repositories/purchase_repository.dart';
import 'package:ebisu/modules/purchases/debit/dataprovider/client/api/entity/pruchases/debit/debit_summary_entity.dart';
import 'package:ebisu/shared/http/request.dart';

class GetDebitSummaryRequest extends Request<DebitSummaryEntity> {
  GetDebitSummaryRequest();

  @override
  String endpoint() => PurchaseEndpoints.PurchaseDebitSummary;

  @override
  DebitSummaryEntity createResponse(Json response) {
    final data = response["data"] as Json;

    return DebitSummaryEntity(
        currentNetAmount: data["current_net_amount"],
        amountToPay: data["amount_to_pay"],
        payedAmount: data["payed_amount"],
        totalAmount: data["total_amount"],
        forecastAmount: data["forecast_amount"],
        currentAmount: data["current_amount"]
    );
  }
}