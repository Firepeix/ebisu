import 'package:ebisu/main.dart';
import 'package:ebisu/modules/expenditure/components/purchases/credit_summaries.dart';
import 'package:ebisu/modules/expenditure/domain/services/purchase_service.dart';
import 'package:ebisu/modules/expenditure/models/purchase/credit_expense_purchase_summary.dart';
import 'package:ebisu/modules/expense/core/domain/expense.dart';
import 'package:ebisu/modules/purchases/debit/core/domain/debit_summary.dart';
import 'package:ebisu/modules/purchases/debit/core/usecase/summarize_debit_usecase.dart';
import 'package:ebisu/modules/purchases/debit/entry/component/debit_summary_card.dart';
import 'package:ebisu/modules/user/entry/component/user_context.dart';
import 'package:ebisu/shared/exceptions/handler.dart';
import 'package:ebisu/shared/state/async_component.dart';
import 'package:ebisu/ui_components/chronos/tab/card_tab_bar.dart';
import 'package:flutter/material.dart';


enum DebitMode {
  FUTURE,
  PRESENT
}

class ExpenditureHomePage extends StatelessWidget {
  final _service = getIt<ExpensePurchaseServiceInterface>();
  final void Function(Expense)? onClickExpense;

  ExpenditureHomePage({this.onClickExpense, super.key});


  @override
  Widget build(BuildContext context) {
    return _Content(_service, onClickExpense: onClickExpense,);
  }
}

class _Content extends StatefulWidget {
  final ExpensePurchaseServiceInterface _service;
  final _debitUseCase = getIt<SummarizeDebitUseCase>();
  final void Function(Expense)? onClickExpense;

  _Content(this._service, { this.onClickExpense });

  Widget _monthSelector(_ContentState state) {
    return CardTabBar(
      tabs: [
        CardTab(title: "Proximo Mes", onPressed: () => state.loadFutureDebitSummary()),
        CardTab(title: "Mes Atual", onPressed: () => state.loadDebitSummary())
      ],
    );
  }

  Widget _getHomeDashboard (_ContentState state, BuildContext buildContext) {
    final summary = state.creditSummaries.length > 0 ? CreditSummaries(summaries: state.creditSummaries, onClickExpense: onClickExpense,) : Container();
    final context = UserContext.of(buildContext);

    return ListView(
      children: [
        Padding(padding: EdgeInsets.only(top: 10)),
        context.show(tutu: _monthSelector(state)),
        state.debitLoaded && state.debitSummary != null ? DebitSummaryCard(state.debitSummary!) : DebitSummaryCardSkeleton(),
        state.creditLoaded ? summary : CreditSummariesSkeleton(state.creditSummaryQuantity),
      ],
    );
  }

  Widget build (_ContentState state, BuildContext context) {
    return RefreshIndicator(
        child: _getHomeDashboard(state, context),
        onRefresh: () async {
          return await state.updateHomeState(cacheLess: true);
        }
    );
  }

  @override
  State<StatefulWidget> createState() => _ContentState();
}

class _ContentState extends State<_Content> with AsyncComponent<_Content>{
  bool creditLoaded = false;
  bool debitLoaded = false;
  int creditSummaryQuantity = 4;
  List<CreditExpensePurchaseSummaryModel> creditSummaries = [];
  DebitSummary? debitSummary;

  @override
  void initState() {
    super.initState();
    updateHomeState();
  }

  Future<void> updateHomeState ({cacheLess = false}) async {
    creditSummaryQuantity = await widget._service.getLocalCreditSummaryQuantity();
    updateState(() {});
    loadCreditExpendituresSummary();
    loadFutureDebitSummary();
  }


  Future<void> loadCreditExpendituresSummary () async {
    updateState(() => creditLoaded = false);

    this.creditSummaries = await widget._service.getPurchaseCreditSummary();

    updateState(() => creditLoaded = true);
  }

  Future<void> loadDebitSummary () async {
    updateState(() => debitLoaded = false);

    final result = await widget._debitUseCase.getDebitSummary();
    result.match(
        ok: (summary) => debitSummary = summary,
        err: (error) => handleError(error, context)
    );

    updateState(() => debitLoaded = true);
  }

  Future<void> loadFutureDebitSummary () async {
    updateState(() => debitLoaded = false);

    final result = await widget._debitUseCase.getFutureDebitSummary();
    result.match(
        ok: (summary) => debitSummary = summary,
        err: (error) => handleError(error, context)
    );

    updateState(() => debitLoaded = true);
  }

  @override
  Widget build(BuildContext context) => widget.build(this, context);

}