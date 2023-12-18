import 'package:ebisu/modules/income/core/domain/income.dart';
import 'package:ebisu/shared/exceptions/result.dart';

abstract class IncomeGateway {
  Future<AnyResult<List<Income>>> getIncomes();
}