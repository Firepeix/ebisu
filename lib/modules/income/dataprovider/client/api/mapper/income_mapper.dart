import 'package:ebisu/modules/common/core/domain/money.dart';
import 'package:ebisu/modules/common/core/domain/source.dart';
import 'package:ebisu/modules/income/core/domain/income.dart';
import 'package:ebisu/modules/income/dataprovider/client/api/entity/purchases/debit/income_entity.dart';
import 'package:ebisu/ui_components/chronos/time/moment.dart';

extension IncomeMapper on IncomeEntity {
  Income toIncome() {
    return Income(
        id: id,
        name: name,
        amount: Money(amount),
        date: Moment.parse(date),
        frequency: frequency,
        source: Source(
            id: sourceId,
            name: sourceName,
            type: SourceType.values.firstWhere((element) => element.name == sourceType)
        )
    );

  }
}