import 'package:ebisu/main.dart';
import 'package:ebisu/modules/travel/core/domain/travel_day.dart';
import 'package:ebisu/modules/travel/core/service/travel_service.dart';
import 'package:ebisu/modules/travel/entry/components/expense/travel_day_expense_form.dart';
import 'package:ebisu/modules/travel/entry/page/expense/travel_expenses_page.dart';
import 'package:ebisu/ui_components/chronos/buttons/float_action_button.dart';
import 'package:ebisu/ui_components/chronos/buttons/simple_fab.dart';
import 'package:ebisu/ui_components/chronos/layout/view_body.dart';
import 'package:flutter/material.dart';

class CreateTravelExpensePage extends StatelessWidget {
  final TravelDay day;
  final _formKey = GlobalKey<ExpenditureFormState>();
  final _service = getIt<TravelExpenseServiceInterface>();

  CreateTravelExpensePage(this.day, {Key? key}) : super(key: key);

  void _handleSubmit(BuildContext context) async {
    final value = _formKey.currentState?.submit();
    if(value != null) {
     // await _service.createTravelExpense(day, value.value1, value.value2);
      routeToPop(context, TravelExpensesPage(day), 2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewBody(
      title: "Adicionar Despesa",
      child: TravelExpenseForm(formKey: _formKey,),
      fab: CFloatActionButton(button: SimpleFAB(() => _handleSubmit(context), icon: Icons.check,)),
    );
  }
}
