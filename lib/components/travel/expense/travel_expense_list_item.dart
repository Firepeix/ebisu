import 'package:ebisu/domain/travel/entities/travel_expense.dart';
import 'package:flutter/material.dart';

class TravelExpenseListItem extends StatelessWidget {
  final TravelExpense expense;
  const TravelExpenseListItem(this.expense, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(expense.description), subtitle: expense.amount);
  }
}
