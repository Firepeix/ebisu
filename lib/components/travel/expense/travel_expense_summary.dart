import 'package:ebisu/ui_components/chronos/labels/money.dart';
import 'package:flutter/material.dart';

class TravelExpenseSummary extends StatelessWidget {
  final Money budget;
  final Money spent;

  const TravelExpenseSummary(this.budget, this.spent, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
          Expanded(child: Card(
            elevation: 3,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 15, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Planejado", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,),),
                      Padding(padding: EdgeInsets.only(top: 15), child: Text(budget.toReal(), style: TextStyle( fontSize: 22, fontWeight: FontWeight.bold),),),
                    ],
                  ),
                ),
              ],
            ),
          )),
          Expanded(child: Card(
            elevation: 3,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 15, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Gasto", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,),),
                      Padding(padding: EdgeInsets.only(top: 15), child: Text(spent.toReal(), style: TextStyle( fontSize: 22, fontWeight: FontWeight.bold),),),
                    ],
                  ),
                ),
              ],
            ),
          )),
      ],
    );
  }
}
