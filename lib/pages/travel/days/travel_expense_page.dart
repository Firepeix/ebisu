import 'package:ebisu/components/travel/day/travel_day_summary.dart';
import 'package:ebisu/components/travel/day/travel_days_list.dart';
import 'package:ebisu/main.dart';
import 'package:ebisu/shared/UI/Components/EbisuCards.dart';
import 'package:ebisu/ui_components/chronos/buttons/float_action_button.dart';
import 'package:ebisu/ui_components/chronos/buttons/simple_fab.dart';
import 'package:ebisu/ui_components/chronos/layout/view_body.dart';
import 'package:flutter/material.dart';

import 'create_expense_day_page.dart';

class TravelExpensePage extends StatelessWidget {
  const TravelExpensePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewBody(
      title: "Gastos de Viagens",
      child: Column(
        children: [
          TravelDaySummary(),
          Padding(padding: EdgeInsets.symmetric(vertical: 20), child: EbisuDivider(),),
          TravelDaysExpenseList(),
        ],
      ),
      fab: CFloatActionButton(button: SimpleFAB(() => routeTo(context, CreateExpenseDayPage()), icon: Icons.add,)),
    );
  }
}
