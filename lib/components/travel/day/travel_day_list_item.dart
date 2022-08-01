import 'package:ebisu/domain/travel/entities/travel_day.dart';
import 'package:ebisu/main.dart';
import 'package:ebisu/pages/travel/expenses/travel_expenses_page.dart';
import 'package:flutter/material.dart';

class TravelDayListItem extends StatelessWidget {
  final TravelDay travelDay;
  const TravelDayListItem(this.travelDay, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(travelDay.title),
      subtitle: travelDay.budget,
      onTap: () => routeTo(context, TravelExpensesPage(travelDay)
      ),);
  }
}
