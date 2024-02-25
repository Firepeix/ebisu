import 'package:ebisu/modules/travel/core/domain/travel_expense.dart';
import 'package:ebisu/ui_components/chronos/list/decorated_list_box.dart';
import 'package:ebisu/ui_components/chronos/list/dismissable_tile.dart';
import 'package:flutter/material.dart';

import 'travel_expense_list_item.dart';

typedef OnDismissExpense = void Function(int index);

class TravelExpensesList extends StatelessWidget {
  final List<TravelExpense> expenses;
  final OnDismissExpense onDismissed;

  TravelExpensesList(this.expenses, {Key? key, required this.onDismissed}) : super(key: key);

  DismissibleTile _buildExpense(BuildContext context, int index) {
    return DismissibleTile(
      child: DecoratedListTileBox(TravelExpenseListItem(expenses[index]), index),
      onDismissed: (_) => onDismissed(index),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: expenses.length,
        itemBuilder: _buildExpense
    );
  }
}
