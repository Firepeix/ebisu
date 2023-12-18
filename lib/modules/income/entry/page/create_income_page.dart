import 'package:ebisu/modules/common/core/domain/source.dart';
import 'package:ebisu/modules/common/entry/components/amount_form.dart';
import 'package:ebisu/modules/expenditure/events/save_expense_notification.dart';
import 'package:ebisu/modules/expenditure/infrastructure/transfer_objects/creates_expense.dart';
import 'package:ebisu/src/UI/Components/Nav/MainButtonPage.dart';
import 'package:ebisu/ui_components/chronos/layout/home_view.dart';
import 'package:flutter/material.dart';

class CreateIncomePage extends StatefulWidget implements MainButtonPage, HomeView {
  static const PAGE_INDEX = 3;

  @override
  int pageIndex() => PAGE_INDEX;

  final VoidCallback? onDone;

  CreateIncomePage({this.onDone});

  @override
  FloatingActionButton getMainButton(BuildContext context, VoidCallback? onPressed) {
    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: "Salvar Ativo",
      child: Icon(Icons.check),
      elevation: 2.0,
    );
  }

  @override
  State<StatefulWidget> createState() => _CreateIncomePageState();
}

class _CreateIncomePageState extends State<CreateIncomePage> {
  List<Source> sources = [];
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    _setInitialState();
  }

  void _setInitialState () async {
    await Future.wait([
      _setBeneficiaries()
    ]);

    setState(() {
      loaded = true;
    });
  }

  Future<void> _setBeneficiaries () async {
    //sources = await widget.service.getSources();
  }

  Future<void> saveIncome(CreatesExpense model) async {
    //final result = await widget.service.createExpense(model);
    //result.let(ok: (_) => widget.onSaveExpense?.call(HomePage.PAGE_INDEX));
  }

  @override
  Widget build(BuildContext context) {
    final features = [
      AmountFormFeature.DATE,
      AmountFormFeature.PAYMENT_TYPE,
      AmountFormFeature.SOURCE,
    ];


    return NotificationListener<SaveExpenseNotification>(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: AmountForm(features: features, onSaved: (a) {}),
        ),
      onNotification: (notification) {
        saveIncome(notification.model);
          return true;
      },
    );
  }
}