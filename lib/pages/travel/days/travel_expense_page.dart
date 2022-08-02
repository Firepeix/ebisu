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
  final _summaryKey = GlobalKey<TravelDaySummaryState>();
  final _listKey = GlobalKey<TravelDaysExpenseListState>();
  TravelExpensePage({Key? key}) : super(key: key);

  void onReturn<T>(T? _) {
    _summaryKey.currentState?.setInitialState();
    _listKey.currentState?.setInitialState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewBody(
      title: "Gastos de Viagens",
      child: Column(
        children: [
          TravelDaySummary(key: _summaryKey,),
          Padding(padding: EdgeInsets.symmetric(vertical: 20), child: EbisuDivider(),),
          Expanded(child: TravelDaysExpenseList(key: _listKey, onReturn: onReturn, onChange: () => onReturn(null),)),
        ],
      ),
      fab: CFloatActionButton(button: SimpleFAB(() => routeTo(context, CreateExpenseDayPage(), onReturn: onReturn), icon: Icons.add,)),
    );
  }

}
