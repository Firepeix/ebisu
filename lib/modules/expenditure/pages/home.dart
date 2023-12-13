import 'package:ebisu/main.dart';
import 'package:ebisu/modules/expenditure/components/purchases/credit_summaries.dart';
import 'package:ebisu/modules/expenditure/domain/services/purchase_service.dart';
import 'package:ebisu/modules/expenditure/models/purchase/credit_expense_purchase_summary.dart';
import 'package:ebisu/modules/purchases/debit/core/usecase/get_debit_summary_usecase.dart';
import 'package:ebisu/modules/purchases/debit/entry/component/debit_summary_card.dart';
import 'package:ebisu/shared/exceptions/handler.dart';
import 'package:ebisu/shared/state/async_component.dart';
import 'package:flutter/material.dart';

import '../../purchases/debit/core/domain/debit_summary.dart';

class ExpenditureHomePage extends StatelessWidget {
  final _service = getIt<ExpensePurchaseServiceInterface>();


  @override
  Widget build(BuildContext context) {
    return _Content(_service);
  }
}

class _Content extends StatefulWidget {
  final ExpensePurchaseServiceInterface _service;
  final _debitUseCase = getIt<GetDebitSummaryUseCase>();

  _Content(this._service);

  Widget _getHomeDashboard (_ContentState state) {
    final summary = state.creditSummaries.length > 0 ? CreditSummaries(summaries: state.creditSummaries,) : Container();

    return ListView(
      children: [
        Padding(padding: EdgeInsets.only(top: 10)),
        state.loaded && state.debitSummary != null ? DebitSummaryCard(state.debitSummary!) : DebitSummaryCardSkeleton(),
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
  DebitSummary? debitSummary;

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
      _setDebitSummary()
    ]);
    updateState(() {
      loaded = true;
    });
  }


  Future<void> _setCreditExpendituresSummary () async {
    this.creditSummaries = await widget._service.getPurchaseCreditSummary();
  }

  Future<void> _setDebitSummary () async {
    final result = await widget._debitUseCase.getDebitSummary();
    result.match(
        ok: (summary) => debitSummary = summary,
        err: (error) => handleError(error, context)
    );
  }

  @override
  Widget build(BuildContext context) => widget.build(this);

}