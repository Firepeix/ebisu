import 'package:ebisu/modules/expense/core/domain/expense.dart';
import 'package:ebisu/modules/expense/entry/components/expense_table.dart';
import 'package:ebisu/ui_components/chronos/bodies/body.dart';
import 'package:ebisu/ui_components/chronos/layout/view_body.dart';
import 'package:flutter/material.dart' as M;

class ExpenseListPage extends M.StatelessWidget {
  final String title;
  final List<ExpenseFilter>? filters;
  final void Function(Expense)? onClickExpense;

  const ExpenseListPage ({required this.title, this.filters, super.key, this.onClickExpense});

  @override
  M.Widget build(M.BuildContext context) {
        return ViewBody(
          title: title,
          body: Body(
            child: M.Container(
              alignment: M.Alignment.topCenter,
              child: ExpenseTable(
                filters: filters,
                onClickExpense: onClickExpense,
              ),
            ),
          ),
        );
  }
}


