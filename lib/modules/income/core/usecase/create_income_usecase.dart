
import 'package:ebisu/modules/common/core/domain/amount_form_model.dart';
import 'package:ebisu/modules/common/core/domain/money.dart';
import 'package:ebisu/modules/income/core/domain/income.dart';
import 'package:ebisu/modules/income/core/gateway/income_gateway.dart';
import 'package:ebisu/shared/exceptions/result.dart';
import 'package:ebisu/ui_components/chronos/time/moment.dart';
import 'package:injectable/injectable.dart';

@injectable
class CreateIncomeUseCase {

  final IncomeGateway _gateway;

  CreateIncomeUseCase(this._gateway);

  Future<AnyResult<void>> createIncome(AmountFormModel model) async {
    return await _gateway.createIncome(_create(model));
  }

  Income _create(AmountFormModel model) {
    return Income(
        id: "",
        name: model.name!,
        amount: Money(model.amount!),
        date: Moment(model.date!),
        frequency: _decodeFrequency(model),
        source: model.source!
    );
  }

  String _decodeFrequency(AmountFormModel model) {
    return "ONCE";
    if (model.currentInstallment == null) {
      return "UNIT";
    }

    if (model.totalInstallments == null) {
      return "1";
    }

    return "${model.currentInstallment}/${model.totalInstallments}";
  }
}
