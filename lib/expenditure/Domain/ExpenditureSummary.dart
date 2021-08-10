import 'package:ebisu/shared/Domain/ValueObjects.dart';

class ExpenditureSummary {
  final String? _title;
  final ExpenditureSummaryBudget _budget;
  final ExpenditureSummarySpent _spent;
  late final ExpenditureSummaryResult _result;


  ExpenditureSummary(this._title, this._budget, this._spent) {
    _result = ExpenditureSummaryResult(_budget.value - _spent.value);
  }


  factory ExpenditureSummary.debit(ExpenditureIncome income, ExpenditureAmountToPay toPay, ExpenditureAmountPayed payed) {
    return DebitExpenditureSummary(income, toPay, payed);
  }

  String? get title => _title;


  int get budgetAmount => _budget.value;

  ExpenditureSummaryBudget get budget => _budget;

  int get spentAmount => _spent.value;

  ExpenditureSummarySpent get spent => _spent;

  ExpenditureSummaryResult get result => _result;
}

class DebitExpenditureSummary extends ExpenditureSummary {
  final ExpenditureAmountPayed _payed;
  DebitExpenditureSummary(ExpenditureIncome income, ExpenditureAmountToPay toPay, this._payed) : super(null, income, toPay);
}

class ExpenditureSummaryBudget extends IntValueObject {
  ExpenditureSummaryBudget(int value) : super(value);

  @override
  ExpenditureSummaryBudget.money(String value) : super.money(value);
}

class ExpenditureSummarySpent extends IntValueObject {
  ExpenditureSummarySpent(int value) : super(value);

  @override
  ExpenditureSummarySpent.money(String value) : super.money(value);
}

class ExpenditureIncome extends ExpenditureSummaryBudget {
  ExpenditureIncome(int value) : super(value);
}

class ExpenditureAmountToPay extends ExpenditureSummarySpent {
  ExpenditureAmountToPay(int value) : super(value);
}

class ExpenditureAmountPayed extends ExpenditureSummarySpent {
  ExpenditureAmountPayed(int value) : super(value);
}

class ExpenditureSummaryResult extends IntValueObject {
  ExpenditureSummaryResult(int value) : super(value);
}