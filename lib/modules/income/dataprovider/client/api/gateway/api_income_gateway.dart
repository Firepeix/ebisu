
import 'package:ebisu/modules/income/core/domain/income.dart';
import 'package:ebisu/modules/income/core/gateway/income_gateway.dart';
import 'package:ebisu/modules/income/dataprovider/client/api/mapper/income_mapper.dart';
import 'package:ebisu/modules/income/dataprovider/client/api/request/create_income_request.dart';
import 'package:ebisu/modules/income/dataprovider/client/api/request/get_incomes_request.dart';
import 'package:ebisu/shared/exceptions/result.dart';
import 'package:ebisu/shared/http/client.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: IncomeGateway)
class ApiIncomeGateway implements IncomeGateway{
  final Caron _caron;

  ApiIncomeGateway(this._caron);

  @override
  Future<AnyResult<List<Income>>> getIncomes() async {
    final request = GetIncomesRequest();
    final result = await _caron.get(request);
    return result.map((value) => value.map((e) => e.toIncome()).toList());
  }

  @override
  Future<AnyResult<void>> createIncome(Income income) async {
    return await _caron.post(CreateIncomeRequest(income));
  }
}