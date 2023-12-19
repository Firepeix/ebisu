import 'package:ebisu/modules/income/core/domain/income.dart';
import 'package:ebisu/modules/income/dataprovider/client/api/income_endpoints.dart';
import 'package:ebisu/shared/http/request.dart';

class CreateIncomeRequest extends EmptyRequest {
  final Income _income;

  CreateIncomeRequest(this._income);

  @override
  String endpoint() => IncomeEndpoints.Incomes;

  Json? body() {
    return {
      "name": _income.name,
      "amount": _income.amount.value,
      "date": _income.date.toLocalDateString(),
      "frequency": _income.frequency,
      "source": {
        "id": _income.source!.id,
        "type": _income.source!.type.name,
      },
    };
  }
}
