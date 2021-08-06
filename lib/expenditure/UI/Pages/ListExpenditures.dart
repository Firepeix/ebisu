import 'package:ebisu/expenditure/Application/ExpenditureCommands.dart';
import 'package:ebisu/expenditure/Domain/Expenditure.dart';
import 'package:ebisu/expenditure/UI/Components/Expenditure.dart';
import 'package:ebisu/shared/Domain/Bus/Command.dart';
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
  Widget build (_ContentState state) {
    return RefreshIndicator(
        child: Padding(padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
            child: ListView.builder(
              itemCount: state.expenditures.length,
              itemBuilder: (BuildContext context, int index) => Padding(
                padding: EdgeInsets.only(top: index == 0 ? 0 : 10),
                child: ExpenditureViewModel(state.expenditures[index]),
              )
            ),
        ),
        onRefresh: () async {
          return await state.setExpenditures(cacheLess: true);
        }
    );
  }

  @override
  State<StatefulWidget> createState() => _ContentState();
}

class _ContentState extends State<Content> with DispatchesCommands {
  List<Expenditure> expenditures = [];

  bool loaded = true;

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
    final expenditures = await dispatch(new GetExpendituresCommand(cacheLess));
    setState(() {
      this.expenditures = expenditures;
    });
    return Future.value();
  }

  @override
  Widget build(BuildContext context) => widget.build(this);

}
