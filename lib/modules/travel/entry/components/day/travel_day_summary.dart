import 'package:ebisu/main.dart';
import 'package:ebisu/modules/common/core/domain/money.dart' as V;
import 'package:ebisu/modules/travel/core/domain/travel_day.dart';
import 'package:ebisu/modules/travel/core/domain/travel_expense.dart';
import 'package:ebisu/modules/travel/core/service/travel_service.dart';
import 'package:ebisu/shared/exceptions/handler.dart';
import 'package:ebisu/shared/utils/matcher.dart';
import 'package:ebisu/ui_components/chronos/labels/money.dart';
import 'package:flutter/material.dart';

class TravelDaySummary extends StatefulWidget {
  final _service = getIt<TravelExpenseServiceInterface>();
  TravelDaySummary({Key? key}) : super(key: key);

  Future<List<TravelExpense>> getExpenses(TravelDay day) async {
    return await _service.getExpenses(day);
  }

  @override
  State<TravelDaySummary> createState() => TravelDaySummaryState();
}

class TravelDaySummaryState extends State<TravelDaySummary> {
  Money budget = Money(0);
  Money spent = Money(0);
  Money difference = Money(0);

  Color get color {
    return Matcher.matchWhen(difference.strata, {
      V.MoneyStrata.positive: Colors.green,
      V.MoneyStrata.negative: Colors.red,
      V.MoneyStrata.zeroed: Colors.blue,
    });
  }


  @override
  void initState() {
    super.initState();
    setInitialState();
  }

  void setInitialState () async {
    final result = await widget._service.getDays();
    result.willFold(
        success: (it) async {
          int _budget = 0;
          int _spent = 0;
          if(it.isNotEmpty) {
            final accumulator = (int value, int element) => value + element;
            _budget = it.map((e) => e.budget.value).reduce(accumulator);
            _spent = 0;
            for (final day in it) {
              final _expenses = await widget.getExpenses(day);
              if (_expenses.isNotEmpty) {
                _spent += _expenses.map((e) => e.amount.value).reduce(accumulator);
              }
            }
          }

          setState(() {
            budget = Money(_budget);
            spent = Money(_spent);
            difference = Money(_budget - _spent);
          });
        },
        failure: (err) => handleError(err, context)
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Card(
              color: theme.colorScheme.primary,
              elevation: 0,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 15, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Planejado", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),),
                        Padding(padding: EdgeInsets.only(top: 5), child: Text(budget.toReal(), style: TextStyle( fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),),),
                      ],
                    ),
                  ),
                ],
              ),
            )),
            Expanded(child: Card(
              elevation: 0,
              color: theme.colorScheme.primary,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 15, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Gasto", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),),
                        Padding(padding: EdgeInsets.only(top: 5), child: Text(spent.toReal(), style: TextStyle( fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),),),
                      ],
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
        Row(
          children: [Expanded(child: Card(
            shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.grey.shade400, width: 0.5),
                borderRadius: BorderRadius.all(Radius.circular(5))),
            elevation: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 15, bottom: 10, left: 15),
                  child: Row(
                    children: [
                      Text("Saldo:  ", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,),),
                      Text(difference.toReal(), style: TextStyle( fontSize: 22, color: color, fontWeight: FontWeight.bold)),
                    ],
                  ),
                )
              ],
            ),
          ))],
        )
      ],
    );
  }
}
