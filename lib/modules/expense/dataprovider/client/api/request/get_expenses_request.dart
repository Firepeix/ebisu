import 'package:ebisu/modules/expense/dataprovider/client/api/entity/expense_entity.dart';
import 'package:ebisu/modules/expense/dataprovider/client/api/expense_endpoints.dart';
import 'package:ebisu/shared/http/request.dart';
import 'package:ebisu/shared/utils/scope.dart';

class GetExpensesRequest extends Request<List<ExpenseEntity>> {
  GetExpensesRequest();

  @override
  String endpoint() => ExpenseEndpoints.Expenses;

  @override
  List<ExpenseEntity> createResponse(Json response) {
    final data = response["data"] as List<dynamic>;

    return data.map((it) {
      final json = it as Json;
      final installments = json["installments"] as Json?;
      final source = json["source"] as Json?;
      final beneficiary = json["beneficiary"] as Json?;
      final card = json["card"] as Json?;

      return ExpenseEntity(
          id: json["id"],
          name: json["name"],
          amount: json["amount"],
          date: json["date"],
          type: json["type"],
          cardId: card?.let((it) => it["id"]),
          currentInstallment: installments?.let((it) => it["current"]),
          totalInstallments: installments?.let((it) => it["total"]),
          sourceId: source?.let((it) => it["id"]),
          sourceName:  source?.let((it) => it["name"]),
          sourceType: source?.let((it) => it["type"]),
          beneficiaryId: beneficiary?.let((it) => it["id"]),
          beneficiaryName: beneficiary?.let((it) => it["name"]),
          beneficiaryType: beneficiary?.let((it) => it["type"])
      );
    }).toList();

  }
}