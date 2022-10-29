import 'package:ebisu/main.dart';
import 'package:ebisu/modules/card/domain/services/card_service.dart';
import 'package:ebisu/modules/card/models/card.dart';
import 'package:ebisu/modules/expenditure/components/expense/expense_form.dart';
import 'package:ebisu/modules/expenditure/domain/expense_source.dart';
import 'package:ebisu/modules/expenditure/domain/services/expense_service.dart';
import 'package:ebisu/modules/expenditure/events/save_expense_notification.dart';
import 'package:ebisu/modules/expenditure/infrastructure/transfer_objects/creates_expense.dart';
import 'package:ebisu/modules/expenditure/models/expense/expenditure_model.dart';
import 'package:ebisu/modules/expenditure/pages/list_expenses.dart';
import 'package:ebisu/shared/Infrastructure/Ebisu.dart';
import 'package:ebisu/src/UI/Components/Nav/MainButtonPage.dart';
import 'package:ebisu/ui_components/chronos/layout/home_view.dart';
import 'package:flutter/material.dart';

class UpdateExpensePage extends StatefulWidget  implements MainButtonPage, HomeView {
  static const PAGE_INDEX = 3;
  @override
  int pageIndex() => 3;

  final String _expenseId;
  final CardServiceInterface cardService = getIt();
  final ExpenseServiceInterface service = getIt();
  final ChangeExistentIndex? onSaveExpense;

  UpdateExpensePage(this._expenseId, {this.onSaveExpense});


  @override
  FloatingActionButton getMainButton(BuildContext context, VoidCallback? onPressed) {
    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: "Salvar Despesa",
      child: Icon(Icons.check),
      elevation: 2.0,
    );
  }

  @override
  State<StatefulWidget> createState() => _UpdateExpensePageState();
}

class _UpdateExpensePageState extends State<UpdateExpensePage> {
  List<CardModel> cards = [];
  List<ExpenseSourceModel> beneficiaries = [];
  ExpenseModel? expense;
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    _setInitialState();
  }

  void _setInitialState () async {
    await Future.wait([
      _setCards(),
      _setBeneficiaries(),
      _setExpense()
    ]);

    setState(() {
      if (expense != null) {
        loaded = true;
      }
    });
  }

  Future<void> _setCards () async {
    cards = await widget.cardService.getCards();
  }


  Future<void> _setBeneficiaries () async {
    beneficiaries = await widget.service.getSources();
  }

  Future<void> _setExpense () async {
    final result = await widget.service.getExpense(widget._expenseId);
    if (result.isOk()) {
      expense = result.unwrap();
    }
  }

  Future<void> saveExpense(CreatesExpense model) async {
    final result = await widget.service.updateExpense(widget._expenseId, model);
    if(result.isOk()) {
      widget.onSaveExpense?.call(ListExpendituresPage.PAGE_INDEX);
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<SaveExpenseNotification>(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: loaded ? ExpenseForm(cards, beneficiaries, model: expense,) : ExpenseFormSkeleton(),
      ),
      onNotification: (notification) {
        saveExpense(notification.model);
        return true;
      },
    );
  }
}
