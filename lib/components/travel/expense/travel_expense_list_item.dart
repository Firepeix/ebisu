import 'package:ebisu/domain/travel/entities/travel_expense.dart';
import 'package:ebisu/ui_components/chronos/list/decorated_list_box.dart';
import 'package:ebisu/ui_components/chronos/list/tile.dart';
import 'package:flutter/material.dart';

class TravelExpenseListItem extends StatelessWidget implements DecoratedTile {
  final TravelExpense expense;
  const TravelExpenseListItem(this.expense, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tile(
        title: Text(expense.description, style: TextStyle(fontWeight: FontWeight.bold),),
        subtitle: expense.amount,
    );
  }

  @override
  String id() {
    return expense.id;
  }
}
