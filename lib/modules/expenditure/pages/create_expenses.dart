import 'package:ebisu/main.dart';
import 'package:ebisu/modules/card/domain/services/card_service.dart';
import 'package:ebisu/modules/card/models/card.dart';
import 'package:ebisu/modules/expenditure/components/expense/expense_form.dart';
import 'package:ebisu/modules/expenditure/domain/expense_source.dart';
import 'package:ebisu/modules/expenditure/domain/services/expense_service.dart';
import 'package:ebisu/modules/expenditure/events/save_expense_notification.dart';
import 'package:ebisu/modules/expenditure/infrastructure/transfer_objects/creates_expense.dart';
import 'package:ebisu/shared/Infrastructure/Ebisu.dart';
import 'package:ebisu/src/UI/Components/Nav/MainButtonPage.dart';
import 'package:ebisu/src/UI/General/HomePage.dart';
import 'package:ebisu/ui_components/chronos/layout/home_view.dart';
import 'package:flutter/material.dart';

class CreateExpenditurePage extends StatefulWidget implements MainButtonPage, HomeView {
  static const PAGE_INDEX = 1;

  @override
  int pageIndex() => PAGE_INDEX;

  final ExpenseServiceInterface service = getIt();
  final CardServiceInterface cardService = getIt();
  final ChangeExistentIndex? onSaveExpense;

  CreateExpenditurePage({this.onSaveExpense});


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
  State<StatefulWidget> createState() => _CreateExpenditurePageState();
}

class _CreateExpenditurePageState extends State<CreateExpenditurePage> {
  List<CardModel> cards = [];
  List<ExpenseSourceModel> beneficiaries = [];
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    _setInitialState();
  }

  void _setInitialState () async {
    await Future.wait([
      _setCards(),
      _setBeneficiaries()
    ]);

    setState(() {
      loaded = true;
    });
  }

  Future<void> _setCards () async {
    final result = await widget.cardService.getCards();
    result.match(ok: (value) => cards = value);
  }


  Future<void> _setBeneficiaries () async {
    beneficiaries = await widget.service.getSources();
  }

  Future<void> saveExpense(CreatesExpense model) async {
    final result = await widget.service.createExpense(model);
    if(result.isOk()) {
      widget.onSaveExpense?.call(HomePage.PAGE_INDEX);
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<SaveExpenseNotification>(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: loaded ? ExpenseForm(cards, beneficiaries,) : ExpenseFormSkeleton(),
        ),
      onNotification: (notification) {
          saveExpense(notification.model);
          return true;
      },
    );
  }
}