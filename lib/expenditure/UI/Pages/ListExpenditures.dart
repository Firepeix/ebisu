import 'package:ebisu/card/Domain/Card.dart';
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
  final List<Expenditure> expenditures = [
    Expenditure(name: ExpenditureName('teste'), type: CardClass.DEBIT, amount: ExpenditureAmount(150050))
  ];


  Widget build (_ContentState state) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 40, horizontal: 30),
      child: ListView.builder(
          itemCount: expenditures.length,
          itemBuilder: (BuildContext context, int index) => Padding(
            padding: EdgeInsets.only(top: index == 0 ? 0 : 30),
            child: ExpenditureViewModel(expenditures[index]),
          )
      ),
    );
  }

  @override
  State<StatefulWidget> createState() => _ContentState();
}

class _ContentState extends State<Content> with DispatchesCommands {
  bool loaded = true;

  @override
  void initState() {
    super.initState();
    _setInitialState();
  }

  void _setInitialState () async {
    setState(() {
      loaded = true;
    });
  }

  /*Future<void> _setCardTypes () async {
    final types = await dispatch(new GetCardTypesCommand());
    setState(() {
      cardTypes = types;
    });
  }*/

  @override
  Widget build(BuildContext context) => widget.build(this);

}
