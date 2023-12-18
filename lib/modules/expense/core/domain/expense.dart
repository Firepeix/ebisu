import 'package:ebisu/modules/common/core/domain/money.dart';
import 'package:ebisu/modules/common/core/domain/source.dart';
import 'package:ebisu/modules/expense/core/domain/installment.dart';
import 'package:ebisu/ui_components/chronos/table/simple_table.dart';
import 'package:ebisu/ui_components/chronos/time/moment.dart';
import 'package:flutter/material.dart' as M;

enum ExpenseType {
  CREDIT("Credito"),
  DEBIT("Debito");

  final String label;

  const ExpenseType(this.label);

  bool isDebit() => this == ExpenseType.DEBIT;
}

class Expense implements Row {
  final String id;
  final String name;
  final Money amount;
  final ExpenseType type;
  final Moment date;
  final Installment? installment;
  final Source? source;
  final Source? beneficiary;

  Expense({required this.id, required this.name, required this.amount, required this.type, required this.date, required this.installment, required this.source, required this.beneficiary,});

  @override
  RowData getRowData() {
    return {
      "name": RowValue(title: name,),
      "date": RowValue(title: date.toString()),
      "installment": RowValue(title: installment?.isFinite() == true ? "${installment!.current}/${installment!.total}" : "${installment?.current ?? "-"}", width: 45, alignment: M.Alignment.center ),
      "value": RowValue(title: amount.toReal(), size: 14, breakAtSpaces: false, width: 85, alignment: M.Alignment.center),
    };
  }
}
