import 'package:ebisu/components/travel/day/travel_days_list.dart';
import 'package:ebisu/main.dart';
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
      child: TravelDaysExpenseList(),
      fab: CFloatActionButton(button: SimpleFAB(() => routeTo(context, CreateExpenseDayPage()), icon: Icons.add,)),
    );
  }
}
//Card(
//         elevation: 4,
//         child: Column(
//           children: [
//             Padding(
//               padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 2),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(summary.title!, style: TextStyle(fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                       color: CardModel
//                           .CardType(summary.title!)
//                           .color),),
//                   Padding(padding: EdgeInsets.only(top: 4),
//                     child: Text('Planejado', style: TextStyle(
//                         fontSize: 14, fontWeight: FontWeight.w400),),),
//                   Text(summary.budget.real, style: TextStyle(
//                       fontSize: 22, fontWeight: FontWeight.bold),),
//                   Padding(padding: EdgeInsets.only(top: 4),
//                     child: Text('Gasto', style: TextStyle(
//                         fontSize: 14, fontWeight: FontWeight.w400),),),
//                   Text(summary.spent.real, style: TextStyle(
//                       fontSize: 22, fontWeight: FontWeight.bold),)
//                 ],
//               ),
//             ),
//             Container(
//               height: 3,
//               decoration: const BoxDecoration(
//                 color: Colors.red,
//                 shape: BoxShape.rectangle,
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.all(5),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Text(summary.result.real, style: TextStyle(fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                       color: summary.result.value > 0
//                           ? Colors.green.shade800
//                           : Colors.red.shade800),),
//                 ],
//               ),
//             )
//           ],
//         ),
//       )