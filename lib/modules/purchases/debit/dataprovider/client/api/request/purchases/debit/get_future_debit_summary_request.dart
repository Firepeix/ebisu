import 'package:ebisu/modules/expenditure/domain/repositories/purchase_repository.dart';
import 'package:ebisu/modules/purchases/debit/dataprovider/client/api/request/purchases/debit/get_debit_summary_request.dart';
import 'package:ebisu/shared/http/request.dart';

class GetFutureDebitSummaryRequest extends GetDebitSummaryRequest {
  final int futureMonths;


  GetFutureDebitSummaryRequest(this.futureMonths);

  @override
  String endpoint() => PurchaseEndpoints.PurchaseFutureSummary;

  Query? query() => {"future": futureMonths};
}