import 'package:ebisu/domain/travel/entities/travel_day.dart';
import 'package:ebisu/domain/travel/entities/travel_expense.dart';
import 'package:ebisu/domain/travel/travel_expense_service.dart';
import 'package:ebisu/main.dart';
import 'package:ebisu/ui_components/chronos/labels/money.dart';
import 'package:flutter/material.dart';

class TravelDaySummary extends StatefulWidget {
  final _service = getIt<TravelExpenseServiceInterface>();
  TravelDaySummary({Key? key}) : super(key: key);

  Future<List<TravelDay>> getDays() async {
    return await _service.getDays();
  }

  Future<List<TravelExpense>> getExpenses(TravelDay day) async {
    return await _service.getExpenses(day);
  }

  @override
  State<TravelDaySummary> createState() => TravelDaySummaryState();
}

class TravelDaySummaryState extends State<TravelDaySummary> {
  Money totalAmount = Money(0);


  @override
  void initState() {
    super.initState();
    setInitialState();
  }

  void setInitialState () async {
    final _days = await widget.getDays();
    int _totalAmount = 0;
    for (int i = 0; i < _days.length; i++) {
      final _expenses = await widget.getExpenses(_days[i]);
      if (_expenses.isNotEmpty) {
        _totalAmount += _expenses.map((e) => e.amount.value).reduce((value, element) => value + element);
      }
    }

    setState(() {
      totalAmount = Money(_totalAmount);
    });
  }

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
                    Text("Gasto Total", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,),),
                    Padding(padding: EdgeInsets.only(top: 15), child: Text(totalAmount.toReal(), style: TextStyle( fontSize: 22, fontWeight: FontWeight.bold),),),
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
