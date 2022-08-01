import 'package:ebisu/components/travel/expense/travel_expenses_list.dart';
import 'package:ebisu/domain/travel/entities/travel_day.dart';
import 'package:ebisu/main.dart';
import 'package:ebisu/pages/travel/expenses/create_travel_expense_page.dart';
import 'package:ebisu/ui_components/chronos/buttons/float_action_button.dart';
import 'package:ebisu/ui_components/chronos/buttons/simple_fab.dart';
import 'package:ebisu/ui_components/chronos/layout/view_body.dart';
import 'package:flutter/material.dart';

class TravelExpensesPage extends StatelessWidget {
  final TravelDay day;

  const TravelExpensesPage(this.day, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewBody(
      title: "Gastos de ${day.title}",
      child: TravelExpensesList(day),
      fab: CFloatActionButton(button: SimpleFAB(() => routeTo(context, CreateTravelExpensePage(day)), icon: Icons.add,)),
    );
  }
}
