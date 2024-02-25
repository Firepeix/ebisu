import 'package:ebisu/components/settings/setup_page.dart';
import 'package:ebisu/main.dart';
import 'package:ebisu/modules/common/core/domain/money.dart';
import 'package:ebisu/modules/travel/core/domain/travel_day.dart';
import 'package:ebisu/modules/travel/core/domain/travel_expense.dart';
import 'package:ebisu/modules/travel/core/service/travel_service.dart';
import 'package:ebisu/modules/travel/entry/components/expense/travel_expense_summary.dart';
import 'package:ebisu/modules/travel/entry/components/expense/travel_expenses_list.dart';
import 'package:ebisu/modules/travel/entry/page/expense/create_travel_expense_page.dart';
import 'package:ebisu/shared/Infrastructure/Repositories/Persistence/GoogleSheetsRepository.dart';
import 'package:ebisu/shared/UI/Components/Buttons.dart';
import 'package:ebisu/shared/UI/Components/EbisuCards.dart';
import 'package:ebisu/shared/services/notification_service.dart';
import 'package:ebisu/ui_components/chronos/buttons/float_action_button.dart';
import 'package:ebisu/ui_components/chronos/layout/view_body.dart';
import 'package:flutter/material.dart';

class TravelExpensesPage extends StatefulWidget {
  final TravelDay day;
  final _service = getIt<TravelExpenseServiceInterface>();
  final notification = getIt<NotificationService>();

  TravelExpensesPage(this.day, {super.key});

  Future<List<TravelExpense>> getExpenses() async {
    return await _service.getExpenses(day);
  }

  Future<void> removeExpense(TravelExpense expense) async {
    return await _service.removeExpense(expense);
  }

  Future<void> saveSheet() async {
    return await _service.saveSheet(day);
  }

  @override
  State<TravelExpensesPage> createState() => _TravelExpensesPageState();
}

class _TravelExpensesPageState extends State<TravelExpensesPage> {
  List<TravelExpense> expenses = [];

  @override
  void initState() {
    super.initState();
    _setInitialState();
  }

  void _setInitialState () async {
    final _expenses = await widget.getExpenses();
    setState(() {
      expenses = _expenses;
    });
  }

  Money _totalAmount() {
    if(expenses.isNotEmpty) {
      return Money(expenses.map((e) => e.amount.value).reduce((value, element) => value + element));
    }
    return Money(0);
  }

  void _handleOnExpenseDismiss(int index) async {
    final expense = expenses[index];
    await widget.removeExpense(expense);
    setState(() {
      expenses.removeAt(index);
    });
  }

  void _handleSave(BuildContext context) async {
    final isSetup = await GoogleSheetsRepository.isSetup();
    if (!isSetup) {
      routeTo(context, SetupPage());
      return;
    }
    widget.notification.displayLoading(context: context);
    await widget.saveSheet();
    widget.notification.displaySuccess(message: "Exportado para planilha com sucesso!", context: context);
  }

  @override
  Widget build(BuildContext context) {
    return ViewBody(
      title: "Gastos de ${widget.day.format()}",
      child: Column(
        children: [
          TravelExpenseSummary(widget.day.budget, _totalAmount()),
          Padding(padding: EdgeInsets.symmetric(vertical: 20), child: EbisuDivider(),),
          Expanded(child: TravelExpensesList(expenses, onDismissed: _handleOnExpenseDismiss,),),
        ],
      ),
      fab: CFloatActionButton(button: ExpandableFab(
        openChild: Icon(Icons.arrow_upward),
        children: [
          ActionButton(
            tooltip: "Criar Despesa",
            icon: Icon(Icons.add, color: Colors.white,),
            onPressed: () => routeTo(context, CreateTravelExpensePage(widget.day)),
          ),
          ActionButton(
            tooltip: "Salvar na Planilha",
            icon: Icon(Icons.save, color: Colors.white,),
            onPressed: () => _handleSave(context),
          )
        ],
      )),
    );
  }
}
