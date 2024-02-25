import 'package:ebisu/main.dart';
import 'package:ebisu/modules/common/core/domain/money.dart';
import 'package:ebisu/modules/travel/core/domain/travel_day.dart';
import 'package:ebisu/modules/travel/core/domain/travel_expense.dart';
import 'package:ebisu/modules/travel/core/service/travel_service.dart';
import 'package:ebisu/shared/exceptions/handler.dart';
import 'package:ebisu/shared/navigator/navigator_interface.dart';
import 'package:ebisu/ui_components/chronos/list/decorated_list_box.dart';
import 'package:ebisu/ui_components/chronos/list/dismissable_tile.dart';
import 'package:ebisu/ui_components/chronos/time/moment.dart';
import 'package:flutter/material.dart';

import 'travel_day_list_item.dart';

class TravelDaysExpenseList extends StatefulWidget {
  final _service = getIt<TravelExpenseServiceInterface>();
  final OnReturnCallback? onReturn;
  final VoidCallback? onChange;
  TravelDaysExpenseList({Key? key, this.onReturn, this.onChange}) : super(key: key);



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
    final result = await widget._service.getDays();
    result.willFold(
        success: (it) async {
          it.sort((a, b) => a.date.compareTo(b.date) * -1);
          List<Money> _spentAmount = [];
          for(final day in it) {
            final _e = await widget.getExpenses(day);
            if (_e.isNotEmpty) {
              _spentAmount.add(Money(_e.map((e) => e.amount.value).reduce((value, element) => value + element)));
            } else {
              _spentAmount.add(Money(0));
            }
          }

          setState(() {
            days = it;
            spentAmount = _spentAmount;
          });
        },
        failure: (err) => handleError(err, context)
    );
  }

  void _handleDismissDay(bool hasBeenDismissed, int index) async {
    if (hasBeenDismissed) {
      final day = days[index];
      await widget.removeDay(day);
      setState(() {
        days.removeAt(index);
        spentAmount.removeAt(index);
        widget.onChange?.call();
      });
      return;
    }
    setState(() {});
  }

  // Gambiarra para não mostrar o botão em cima de uma lista
  Visibility _buildDay(BuildContext context, int index) {
    final shouldNotAppear = days.length == index;
    return Visibility(
        maintainAnimation: true,
        maintainState: true,
        maintainSize: true,
        visible: !shouldNotAppear,
        child: !shouldNotAppear ? DismissibleTile(
          confirmOnDismissed: true,
          child: DecoratedListTileBox(TravelDayListItem(days[index], spentAmount[index], onReturn: widget.onReturn,), index),
          onDismissed: (hasBeenDismissed) => _handleDismissDay(hasBeenDismissed, index),
        ) : DecoratedListTileBox(TravelDayListItem(TravelDay(date: Moment.now(), budget: Money(0)), Money(0), showBottomBorder: false,), index - 1,)
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
