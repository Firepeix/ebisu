import 'package:ebisu/expenditure/Application/ExpenditureCommands.dart';
import 'package:ebisu/expenditure/UI/Components/Expenditure.dart';
import 'package:ebisu/expenditure/domain/Expenditure.dart';
import 'package:ebisu/shared/Domain/Bus/Command.dart';
import 'package:ebisu/shared/Domain/ExceptionHandler/ExceptionHandler.dart';
import 'package:ebisu/src/Domain/Pages/AbstractPage.dart';
import 'package:flutter/material.dart';

class ListExpendituresPage extends AbstractPage {
  static const PAGE_INDEX = 2;

  @override
  Widget build(BuildContext context) {
    return Content();
  }
}


class Content extends StatefulWidget {
  Widget _getExpenditureView (_ContentState state) {
    return ListView.builder(
        itemCount: state.expenditures.length,
        itemBuilder: (BuildContext context, int index) => Padding(
          padding: EdgeInsets.only(top: index == 0 ? 0 : 10),
          child: ExpenditureViewModel(state.expenditures[index]),
        )
    );
  }

  Widget _getExpenditureSkeletonView () {
    return ListView.builder(
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) => Padding(
          padding: EdgeInsets.only(top: index == 0 ? 0 : 10),
          child: ExpenditureSkeletonView(),
        )
    );
  }

  Widget build (_ContentState state) {
    return RefreshIndicator(
        child: Padding(padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: state.loaded ? _getExpenditureView(state) : _getExpenditureSkeletonView(),
        ),
        onRefresh: () async {
          return await state.setExpenditures(cacheLess: true);
        }
    );
  }

  @override
  State<StatefulWidget> createState() => _ContentState();
}

class _ContentState extends State<Content> with DispatchesCommands, DisplaysErrors {
  List<Expenditure> expenditures = [];
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

  Future<void> setExpenditures ({cacheLess: false}) async {
    try {
      final expenditures = await dispatch(new GetExpendituresCommand(cacheLess));
      setState(() {
        this.expenditures = expenditures;
      });
    } catch (error) {
      displayError(error, context: context);
    }
  }

  @override
  Widget build(BuildContext context) => widget.build(this);

}
