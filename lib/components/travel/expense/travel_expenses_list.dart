import 'package:ebisu/domain/travel/entities/travel_expense.dart';
import 'package:flutter/material.dart';

import 'travel_expense_list_item.dart';

class TravelExpensesList extends StatelessWidget {
  final List<TravelExpense> expenses;

  TravelExpensesList(this.expenses, {Key? key}) : super(key: key);

  TravelExpenseListItem _buildDay(BuildContext context, int index) {
    return TravelExpenseListItem(expenses[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
            shrinkWrap: true,
            itemCount: expenses.length,
            itemBuilder: _buildDay
        )
      ],
    );
  }
}
