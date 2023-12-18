import 'package:ebisu/modules/income/dataprovider/client/api/entity/purchases/debit/income_entity.dart';
import 'package:ebisu/modules/income/dataprovider/client/api/income_endpoints.dart';
import 'package:ebisu/shared/http/request.dart';

class
GetIncomesRequest extends Request<List<IncomeEntity>> {
  GetIncomesRequest();

  @override
  String endpoint() => IncomeEndpoints.Incomes;

  @override
  List<IncomeEntity> createResponse(Json response) {
    final data = response["data"] as List<dynamic>;

    return data.map((it) {
      final json = it as Json;
      return IncomeEntity(
          id: json["id"],
          name: json["name"],
          amount: json["amount"],
          date: json["date"],
          frequency: json["frequency"],
          sourceId: json["source"]["id"],
          sourceName: json["source"]["name"],
          sourceType: json["source"]["type"]
      );
    }).toList();

  }
}