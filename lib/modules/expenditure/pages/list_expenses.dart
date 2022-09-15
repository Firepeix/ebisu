import 'package:ebisu/main.dart';
import 'package:ebisu/modules/expenditure/components/expense/expense_card.dart';
import 'package:ebisu/modules/expenditure/domain/services/expense_service.dart';
import 'package:ebisu/modules/expenditure/models/expense/expenditure_model.dart';
import 'package:ebisu/src/Domain/Pages/AbstractPage.dart';
import 'package:flutter/material.dart';

class ListExpendituresPage extends AbstractPage {
  static const PAGE_INDEX = 2;
  final ExpenseServiceInterface _service = getIt<ExpenseServiceInterface>();

  @override
  Widget build(BuildContext context) {
    return Content(_service);
  }
}


class Content extends StatefulWidget {
  final ExpenseServiceInterface _service;

  Content(this._service);

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

  Widget _getExpenditureView () {
    return ListView.builder(
        itemCount: expenditures.length,
        itemBuilder: (BuildContext context, int index) => Padding(
          padding: EdgeInsets.only(top: index == 0 ? 0 : 10),
          child: ExpenseListCard(expenditures[index]),
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
