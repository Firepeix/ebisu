import 'package:ebisu/ebisu.dart';
import 'package:ebisu/main.dart';
import 'package:ebisu/modules/expenditure/components/expense/expense_card.dart';
import 'package:ebisu/modules/expenditure/domain/services/expense_service.dart';
import 'package:ebisu/modules/expenditure/models/expense/expenditure_model.dart';
import 'package:ebisu/modules/expenditure/pages/edit_expense.dart';
import 'package:ebisu/shared/state/async_component.dart';
import 'package:ebisu/ui_components/chronos/layout/home_view.dart';
import 'package:ebisu/ui_components/chronos/list/dismissable_tile.dart';
import 'package:flutter/material.dart';

class ListExpendituresPage extends StatefulWidget implements HomeView {
  static const PAGE_INDEX = 2;

  @override
  int pageIndex() => PAGE_INDEX;

  final ExpenseServiceInterface _service = getIt<ExpenseServiceInterface>();
  final Function? onClickExpense;
  final ChangeExistentIndex? onSaveExpense;

  ListExpendituresPage({this.onClickExpense, this.onSaveExpense});

  @override
  State<StatefulWidget> createState() => _ListExpendituresPageState();
}
class _ListExpendituresPageState extends State<ListExpendituresPage> with AsyncComponent<ListExpendituresPage> {
  List<ExpenseModel> expenditures = [];
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    _setInitialState();
  }

  void _setInitialState () async {
    setExpenditures();
    updateState(() {
      loaded = true;
    });
  }

  Future<void> setExpenditures() async {
    final expenditures = await widget._service.getCurrentExpenses();
    updateState(() {
      this.expenditures = expenditures;
    });
  }

  void _deleteExpense(bool hasBeenDismissed, int index) async {
    if (hasBeenDismissed) {
      final result = await widget._service.deleteExpense(expenditures[index]);
      result.let(ok: (_) {
        setState(() {
          expenditures.removeAt(index);
        });
      });
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
              widget.onClickExpense?.call(UpdateExpensePage(model.id, onSaveExpense: widget.onSaveExpense,));
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
