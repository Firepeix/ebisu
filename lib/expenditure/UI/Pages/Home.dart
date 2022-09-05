import 'package:ebisu/expenditure/domain/ExpenditureSummary.dart';
import 'package:ebisu/expenditure/domain/services/purchase_service.dart';
import 'package:ebisu/expenditure/models/purchase/credit_expense_purchase_summary.dart';
import 'package:ebisu/main.dart';
import 'package:ebisu/shared/Domain/Bus/Command.dart';
import 'package:ebisu/shared/Domain/ExceptionHandler/ExceptionHandler.dart';
import 'package:ebisu/shared/UI/Components/Title.dart';
import 'package:ebisu/src/Domain/Pages/AbstractPage.dart';
import 'package:flutter/material.dart';

import '../../components/purchases/credit_summaries.dart';

class ExpenditureHomePage extends AbstractPage {
  final _service = getIt<ExpensePurchaseServiceInterface>();


  @override
  Widget build(BuildContext context) {
    return _Content(_service);
  }
}

class _Content extends StatefulWidget {
  final ExpensePurchaseServiceInterface _service;

  _Content(this._service);

  Widget _getHomeDashboard (_ContentState state) => ListView(
    children: [
      Padding(padding: EdgeInsets.only(top: 20), child: EbisuTitle('Resumo de Credito'),),
      state.loaded ? CreditSummaries(summaries: state.creditSummaries,) : CreditSummariesSkeleton(),
      //EbisuTitle('Resumo de Debito'),
      //state.loaded ? DebitSummary(state.debitSummary!) : DebitSummariesSkeleton(),
    ],
  );

  Widget build (_ContentState state) {
    return RefreshIndicator(
        child: _getHomeDashboard(state),
        onRefresh: () async {
          return await state.updateHomeState(cacheLess: true);
        }
    );
  }

  @override
  State<StatefulWidget> createState() => _ContentState();
}

class _ContentState extends State<_Content> with DispatchesCommands, DisplaysErrors {
  bool loaded = false;
  List<CreditExpensePurchaseSummaryModel> creditSummaries = [];
  DebitExpenditureSummary? debitSummary;

  @override
  void initState() {
    super.initState();
    updateHomeState();
  }

  Future<void> updateHomeState ({cacheLess: false}) async {
    try {
      await Future.wait([
        _setCreditExpendituresSummary(),
        _setDebitExpendituresSummary(cacheLess)
      ]);
    } catch (error) {
      displayError(error, context: context);
    }
    setState(() {
      loaded = true;
    });
  }


  Future<void> _setCreditExpendituresSummary () async {
    this.creditSummaries = await widget._service.getPurchaseCreditSummary();
  }

  Future<void> _setDebitExpendituresSummary (bool cacheLess) async {
    //final summary = await dispatch(new GetDebitExpenditureSummaryCommand(cacheLess));
    this.debitSummary = DebitExpenditureSummary(ExpenditureIncome(0), ExpenditureAmountToPay(0), ExpenditureAmountPayed(0));
    return Future.value();
  }

  @override
  Widget build(BuildContext context) => widget.build(this);

}