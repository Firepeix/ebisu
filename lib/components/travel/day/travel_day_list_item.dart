import 'package:ebisu/domain/travel/entities/travel_day.dart';
import 'package:ebisu/main.dart';
import 'package:ebisu/pages/travel/expenses/travel_expenses_page.dart';
import 'package:ebisu/shared/navigator/navigator_interface.dart';
import 'package:ebisu/shared/utils/matcher.dart';
import 'package:ebisu/ui_components/chronos/labels/money.dart';
import 'package:ebisu/ui_components/chronos/list/decorated_list_box.dart';
import 'package:ebisu/ui_components/chronos/list/tile.dart';
import 'package:flutter/material.dart';

class TravelDayListItem extends StatelessWidget implements DecoratedTile {
  final TravelDay travelDay;
  final Money spent;
  final OnReturnCallback? onReturn;
  final bool showBottomBorder;
  const TravelDayListItem(this.travelDay, this.spent, {Key? key, this.onReturn, this.showBottomBorder = true}) : super(key: key);

  Color color() {
    final difference = travelDay.budget - spent;
    return Matcher.matchWhen(difference.strata, {
      MoneyStrata.positive: Colors.green,
      MoneyStrata.negative: Colors.red,
      MoneyStrata.zeroed: Colors.blue,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Tile(
      title: Text(travelDay.title),
      subtitle: travelDay.budget,
      trailing: Money(spent.value, color: Theme.of(context).colorScheme.primary,),
      onTap: () => routeTo(context, TravelExpensesPage(travelDay), onReturn: onReturn),
      showBottomBorder: showBottomBorder
    );
  }

  @override
  String id() {
    return travelDay.id;
  }
}
