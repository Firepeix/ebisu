
import 'package:ebisu/modules/income/core/domain/income.dart';
import 'package:ebisu/modules/income/core/gateway/income_gateway.dart';
import 'package:ebisu/shared/exceptions/result.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetIncomesUseCase {

  final IncomeGateway _gateway;

  GetIncomesUseCase(this._gateway);

  Future<AnyResult<List<Income>>> getIncomes({int futureMonth = 0}) async {
    return await _gateway.getIncomes(futureMonth: futureMonth);
  }
}