import 'package:ebisu/components/travel/expense/travel_expense_summary.dart';
import 'package:ebisu/components/travel/expense/travel_expenses_list.dart';
import 'package:ebisu/domain/travel/entities/travel_day.dart';
import 'package:ebisu/domain/travel/entities/travel_expense.dart';
import 'package:ebisu/domain/travel/travel_expense_service.dart';
import 'package:ebisu/main.dart';
import 'package:ebisu/pages/travel/expenses/create_travel_expense_page.dart';
import 'package:ebisu/shared/UI/Components/EbisuCards.dart';
import 'package:ebisu/ui_components/chronos/buttons/float_action_button.dart';
import 'package:ebisu/ui_components/chronos/buttons/simple_fab.dart';
import 'package:ebisu/ui_components/chronos/labels/money.dart';
import 'package:ebisu/ui_components/chronos/layout/view_body.dart';
import 'package:flutter/material.dart';

class TravelExpensesPage extends StatefulWidget {
  final TravelDay day;
  final _service = getIt<TravelExpenseServiceInterface>();

  TravelExpensesPage(this.day, {Key? key}) : super(key: key);

  Future<List<TravelExpense>> getExpenses() async {
    return await _service.getExpenses(day);
  }

  @override
  State<TravelExpensesPage> createState() => _TravelExpensesPageState();
}

class _TravelExpensesPageState extends State<TravelExpensesPage> {
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

  Money _totalAmount() {
    if(expenses.isNotEmpty) {
      return Money(expenses.map((e) => e.amount.value).reduce((value, element) => value + element));
    }
    return Money(0);
  }

  @override
  Widget build(BuildContext context) {
    return ViewBody(
      title: "Gastos de ${widget.day.title}",
      child: Column(
        children: [
          TravelExpenseSummary(widget.day.budget, _totalAmount()),
          Padding(padding: EdgeInsets.symmetric(vertical: 20), child: EbisuDivider(),),
          TravelExpensesList(expenses),
        ],
      ),
      fab: CFloatActionButton(button: SimpleFAB(() => routeTo(context, CreateTravelExpensePage(widget.day)), icon: Icons.add,)),
    );
  }
}
