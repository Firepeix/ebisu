import 'package:ebisu/modules/common/core/domain/money.dart';
import 'package:ebisu/modules/purchases/debit/core/domain/debit_summary.dart';
import 'package:ebisu/modules/purchases/debit/dataprovider/client/api/entity/pruchases/debit/debit_summary_entity.dart';

extension DebitMapper on DebitSummaryEntity {
  DebitSummary toDebitSummary() {
    return DebitSummary(
        currentNetAmount: Money(currentNetAmount),
        amountToPay: Money(amountToPay),
        payedAmount: Money(payedAmount),
        totalAmount: Money(totalAmount),
        forecastAmount: Money(forecastAmount),
        currentAmount: Money(currentAmount)
    );
  }
}