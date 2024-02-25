import 'package:ebisu/modules/common/core/domain/money.dart';
import 'package:ebisu/modules/common/core/domain/source.dart';
import 'package:ebisu/modules/expense/core/domain/expense.dart';
import 'package:ebisu/modules/expense/core/domain/installment.dart';
import 'package:ebisu/modules/expense/dataprovider/client/api/entity/expense_entity.dart';
import 'package:ebisu/shared/utils/scope.dart';
import 'package:ebisu/ui_components/chronos/time/moment.dart';

extension ExpenseMapper on ExpenseEntity {
  Expense toExpense() => Expense(
      id: id,
      name: name,
      amount: Money(amount),
      type: ExpenseType.values.firstWhere((element) => element.name == type),
      date: Moment.parse(date),
      cardId: cardId,
      installment: currentInstallment?.let((it) => Installment(current: it, total: totalInstallments)),
      source: sourceId?.let((it) => Source(
          id: it,
          name: sourceName!,
          type: SourceType.values.firstWhere((element) => element.name == sourceType)
      )),
      beneficiary: beneficiaryId?.let((it) => Source(
          id: it,
          name: beneficiaryName!,
          type: SourceType.values.firstWhere((element) => element.name == beneficiaryType)
      )),
  );
}