import 'package:ebisu/domain/travel/entities/travel_day.dart';
import 'package:ebisu/main.dart';
import 'package:ebisu/pages/travel/expenses/travel_expenses_page.dart';
import 'package:ebisu/shared/navigator/navigator_interface.dart';
import 'package:ebisu/ui_components/chronos/list/decorated_list_box.dart';
import 'package:ebisu/ui_components/chronos/list/tile.dart';
import 'package:flutter/material.dart';

class TravelDayListItem extends StatelessWidget implements DecoratedTile {
  final TravelDay travelDay;
  final OnReturnCallback? onReturn;
  const TravelDayListItem(this.travelDay, {Key? key, this.onReturn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tile(
      title: Text(travelDay.title),
      subtitle: travelDay.budget,
      onTap: () => routeTo(context, TravelExpensesPage(travelDay), onReturn: onReturn),);
  }

  @override
  String id() {
    return travelDay.id;
  }
}
