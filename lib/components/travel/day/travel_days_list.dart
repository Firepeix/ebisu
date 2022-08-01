import 'package:ebisu/domain/travel/entities/travel_day.dart';
import 'package:ebisu/domain/travel/travel_expense_service.dart';
import 'package:ebisu/main.dart';
import 'package:flutter/material.dart';

import 'travel_day_list_item.dart';

class TravelDaysExpenseList extends StatefulWidget {
  final _service = getIt<TravelExpenseServiceInterface>();
  TravelDaysExpenseList({Key? key}) : super(key: key);

  Future<List<TravelDay>> getDays() async {
    return await _service.getDays();
  }

  @override
  State<TravelDaysExpenseList> createState() => _TravelDaysExpenseListState();
}

class _TravelDaysExpenseListState extends State<TravelDaysExpenseList> {
  List<TravelDay> days = [];


  @override
  void initState() {
    super.initState();
    _setInitialState();
  }

  void _setInitialState () async {
    final _days = await widget.getDays();
    setState(() {
      days = _days;
    });
  }

  TravelDayListItem _buildDay(BuildContext context, int index) {
    return TravelDayListItem(days[index]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
            shrinkWrap: true,
            itemCount: days.length,
            itemBuilder: _buildDay
        )
      ],
    );
  }
}
