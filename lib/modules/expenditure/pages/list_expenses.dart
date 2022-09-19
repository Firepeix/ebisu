import 'package:ebisu/main.dart';
import 'package:ebisu/modules/expenditure/components/expense/expense_card.dart';
import 'package:ebisu/modules/expenditure/domain/services/expense_service.dart';
import 'package:ebisu/modules/expenditure/models/expense/expenditure_model.dart';
import 'package:ebisu/modules/expenditure/pages/edit_expense.dart';
import 'package:ebisu/src/Domain/Pages/AbstractPage.dart';
import 'package:ebisu/ui_components/chronos/list/dismissable_tile.dart';
import 'package:flutter/material.dart';

class ListExpendituresPage extends AbstractPage {
  static const PAGE_INDEX = 2;
  final ExpenseServiceInterface _service = getIt<ExpenseServiceInterface>();

  ListExpendituresPage({required onClickExpense}) : super(onChangeTo: onClickExpense);


  @override
  Widget build(BuildContext context) {
    return Content(_service, onClickExpense: onChangeTo,);
  }

  @override
  int pageIndex() => PAGE_INDEX;
}


class Content extends StatefulWidget {
  final ExpenseServiceInterface _service;
  final Function? onClickExpense;

  Content(this._service, {this.onClickExpense});

  @override
  State<StatefulWidget> createState() => _ContentState();
}

class _ContentState extends State<Content> {
  List<ExpenseModel> expenditures = [];
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    _setInitialState();
  }

  void _setInitialState () async {
    setExpenditures();
    setState(() {
      loaded = true;
    });
  }

  Future<void> setExpenditures() async {
    final expenditures = await widget._service.getCurrentExpenses();
    setState(() {
      this.expenditures = expenditures;
    });
  }

  void _deleteExpense(bool hasBeenDismissed, int index) async {
    print([hasBeenDismissed, index]);
    if (hasBeenDismissed) {
      final result = await widget._service.deleteExpense(expenditures[index]);
      if (result.isOk()) {
        setState(() {
          expenditures.removeAt(index);
        });
        return;
      }
    }
    setState(() {});
  }

  Widget _getExpenditureView () {
    return ListView.builder(
        itemCount: expenditures.length,
        itemBuilder: (BuildContext context, int index) => Padding(
          padding: EdgeInsets.only(top: index == 0 ? 0 : 10),
          child: DismissibleTile(
            confirmOnDismissed: true,
            child: ExpenseListCard(expenditures[index], onClick: (model) {
              widget.onClickExpense?.call(UpdateExpensePage(model.id, onChangePageTo: null,));
            },),
            onDismissed: (hasBeenDismissed) => _deleteExpense(hasBeenDismissed, index),
          ),
        )
    );
  }

  Widget _getExpenditureSkeletonView () {
    return ListView.builder(
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) => Padding(
          padding: EdgeInsets.only(top: index == 0 ? 0 : 10),
          child: CardModelSkeleton(),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        child: Padding(padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: loaded ? _getExpenditureView() : _getExpenditureSkeletonView(),
        ),
        onRefresh: () async {
          return await setExpenditures();
        }
    );
  }

}
