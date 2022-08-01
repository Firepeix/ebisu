import 'package:ebisu/domain/travel/entities/travel_day.dart';
import 'package:ebisu/domain/travel/entities/travel_expense.dart';
import 'package:ebisu/domain/travel/travel_expense_service.dart';
import 'package:ebisu/main.dart';
import 'package:flutter/material.dart';

import 'travel_expense_list_item.dart';

class TravelExpensesList extends StatefulWidget {
  final TravelDay day;
  final _service = getIt<TravelExpenseServiceInterface>();
  TravelExpensesList(this.day, {Key? key}) : super(key: key);

  Future<List<TravelExpense>> getExpenses() async {
    return await _service.getExpenses(day);
  }

  @override
  State<TravelExpensesList> createState() => _TravelDayExpensesListState();
}

class _TravelDayExpensesListState extends State<TravelExpensesList> {
  List<TravelExpense> expenses = [];


  @override
  void initState() {
    super.initState();
    _setInitialState();
  }

  void _setInitialState () async {
    final _expenses = await widget.getExpenses();
    setState(() {
      expenses = _expenses;
    });
  }

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
