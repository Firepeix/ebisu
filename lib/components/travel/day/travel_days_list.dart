import 'package:ebisu/domain/travel/entities/travel_day.dart';
import 'package:ebisu/domain/travel/entities/travel_expense.dart';
import 'package:ebisu/domain/travel/travel_expense_service.dart';
import 'package:ebisu/main.dart';
import 'package:ebisu/shared/navigator/navigator_interface.dart';
import 'package:ebisu/ui_components/chronos/labels/money.dart';
import 'package:ebisu/ui_components/chronos/list/decorated_list_box.dart';
import 'package:ebisu/ui_components/chronos/list/dismissable_tile.dart';
import 'package:flutter/material.dart';

import 'travel_day_list_item.dart';

class TravelDaysExpenseList extends StatefulWidget {
  final _service = getIt<TravelExpenseServiceInterface>();
  final OnReturnCallback? onReturn;
  final VoidCallback? onChange;
  TravelDaysExpenseList({Key? key, this.onReturn, this.onChange}) : super(key: key);

  Future<List<TravelDay>> getDays() async {
    return await _service.getDays();
  }

  Future<List<TravelExpense>> getExpenses(TravelDay day) async {
    return await _service.getExpenses(day);
  }

  Future<void> removeDay(TravelDay day) async {
    return await _service.removeDay(day);
  }

  @override
  State<TravelDaysExpenseList> createState() => TravelDaysExpenseListState();
}

class TravelDaysExpenseListState extends State<TravelDaysExpenseList> {
  List<TravelDay> days = [];
  List<Money> spentAmount = [];


  @override
  void initState() {
    super.initState();
    setInitialState();
  }

  void setInitialState () async {
    final _days = await widget.getDays();
    _days.sort((a, b) => a.date.compareTo(b.date) * -1);
    List<Money> _spentAmount = [];
    for(final day in _days) {
      final _e = await widget.getExpenses(day);
      if (_e.isNotEmpty) {
        _spentAmount.add(Money(_e.map((e) => e.amount.value).reduce((value, element) => value + element)));
      } else {
        _spentAmount.add(Money(0));
      }
    }

    setState(() {
      days = _days;
      spentAmount = _spentAmount;
    });
  }

  void _handleDismissDay(int index) async {
    final day = days[index];
    await widget.removeDay(day);
    setState(() {
      days.removeAt(index);
      spentAmount.removeAt(index);
      widget.onChange?.call();
    });
  }

  Visibility _buildDay(BuildContext context, int index) {
    final shouldNotAppear = days.length == index;
    return Visibility(
        maintainAnimation: true,
        maintainState: true,
        maintainSize: true,
        visible: !shouldNotAppear,
        child: !shouldNotAppear ? DismissibleTile(
          child: DecoratedListTileBox(TravelDayListItem(days[index], spentAmount[index], onReturn: widget.onReturn,), index),
          onDismissed: (_) => _handleDismissDay(index),
        ) : DecoratedListTileBox(TravelDayListItem(TravelDay(DateTime.now(), Money(0)), Money(0), showBottomBorder: false,), index - 1,)
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: days.length + 1,
        itemBuilder: _buildDay
    );
  }
}
