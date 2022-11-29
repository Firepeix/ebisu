import 'package:ebisu/main.dart';
import 'package:ebisu/modules/expenditure/components/purchases/credit_summaries.dart';
import 'package:ebisu/modules/expenditure/domain/ExpenditureSummary.dart';
import 'package:ebisu/modules/expenditure/domain/services/purchase_service.dart';
import 'package:ebisu/modules/expenditure/models/purchase/credit_expense_purchase_summary.dart';
import 'package:ebisu/shared/state/async_component.dart';
import 'package:flutter/material.dart';

class ExpenditureHomePage extends StatelessWidget {
  final _service = getIt<ExpensePurchaseServiceInterface>();


  @override
  Widget build(BuildContext context) {
    return _Content(_service);
  }
}

class _Content extends StatefulWidget {
  final ExpensePurchaseServiceInterface _service;

  _Content(this._service);

  Widget _getHomeDashboard (_ContentState state) {
    final summary = state.creditSummaries.length > 0 ? CreditSummaries(summaries: state.creditSummaries,) : Container();
    return ListView(
      children: [
        //Padding(padding: EdgeInsets.only(top: 20), child: EbisuTitle('Resumo de Credito'),),
        state.loaded ? summary : CreditSummariesSkeleton(state.creditSummaryQuantity),
      ],
    );
  }

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

class _ContentState extends State<_Content> with AsyncComponent<_Content>{
  bool loaded = false;
  int creditSummaryQuantity = 4;
  List<CreditExpensePurchaseSummaryModel> creditSummaries = [];
  DebitExpenditureSummary? debitSummary;

  @override
  void initState() {
    super.initState();
    updateHomeState();
  }

  Future<void> updateHomeState ({cacheLess: false}) async {
    creditSummaryQuantity = await widget._service.getLocalCreditSummaryQuantity();
    updateState(() {});
    await Future.wait([
      _setCreditExpendituresSummary(),
      _setDebitExpendituresSummary(cacheLess)
    ]);
    updateState(() {
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