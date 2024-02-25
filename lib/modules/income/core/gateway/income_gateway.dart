import 'package:ebisu/modules/income/core/domain/income.dart';
import 'package:ebisu/shared/exceptions/result.dart';

abstract class IncomeGateway {
  Future<AnyResult<List<Income>>> getIncomes({int futureMonth = 0});
  Future<AnyResult<void>> createIncome(Income income);
}