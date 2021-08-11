import 'package:ebisu/shared/Domain/ValueObjects.dart';
import 'package:flutter/material.dart';

class ExpenditureSummary {
  final String? _title;
  final ExpenditureSummaryBudget _budget;
  final ExpenditureSummarySpent _spent;
  late final ExpenditureSummaryResult _result;


  ExpenditureSummary(this._title, this._budget, this._spent) {
    _result = ExpenditureSummaryResult(_budget.value - _spent.value);
  }

  String? get title => _title;


  int get budgetAmount => _budget.value;

  ExpenditureSummaryBudget get budget => _budget;

  int get spentAmount => _spent.value;

  ExpenditureSummarySpent get spent => _spent;

  ExpenditureSummaryResult get result => _result;
}

class DebitExpenditureSummary {
  final ExpenditureIncome _income;
  final ExpenditureAmountToPay _toPay;
  final ExpenditureAmountPayed _payed;
  final List<DebitExpenditureSummarySeries> _series = [];
  late final ExpenditureSummaryResult _result;

  DebitExpenditureSummary(this._income, this._toPay, this._payed) {
    _result = ExpenditureSummaryResult(_income.value - _toPay.value);
    _addSeries();
  }

  void _addSeries () {
    _series.add(DebitExpenditureSummarySeries('Entrada', _income, Colors.green));
    _series.add(DebitExpenditureSummarySeries('A Pagar', _toPay, Colors.red));
    _series.add(DebitExpenditureSummarySeries('Restante', _result, Colors.blue));
    _series.add(DebitExpenditureSummarySeries('Pago', _payed, Colors.purple));
  }

  List<DebitExpenditureSummarySeries> get series => _series;

  ExpenditureAmountPayed get payed => _payed;

  ExpenditureAmountToPay get toPay => _toPay;

  ExpenditureIncome get income => _income;
}

class DebitExpenditureSummarySeries {
  final String label;
  final _DebitSummaryValue value;
  final MaterialColor color;

  DebitExpenditureSummarySeries(this.label, this.value, this.color);
}

class ExpenditureSummaryBudget extends IntValueObject {
  ExpenditureSummaryBudget(int value) : super(value);
}

class ExpenditureSummarySpent extends IntValueObject {
  ExpenditureSummarySpent(int value) : super(value);
}

class _DebitSummaryValue extends IntValueObject {
  _DebitSummaryValue(int value) : super(value);
}

class ExpenditureIncome extends _DebitSummaryValue {
  ExpenditureIncome(int value) : super(value);
}

class ExpenditureAmountToPay extends _DebitSummaryValue {
  ExpenditureAmountToPay(int value) : super(value);
}

class ExpenditureAmountPayed extends _DebitSummaryValue {
  ExpenditureAmountPayed(int value) : super(value);
}

class ExpenditureSummaryResult extends _DebitSummaryValue {
  ExpenditureSummaryResult(int value) : super(value);
}