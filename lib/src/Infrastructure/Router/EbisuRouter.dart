import 'package:ebisu/src/Domain/Pages/AbstractPage.dart';
import 'package:ebisu/src/UI/Expenditures/Create.dart';
import 'package:ebisu/src/UI/Expenditures/List.dart';
import 'package:ebisu/src/UI/General/HomePage.dart';

class EbisuRouter {
  List<AbstractPage> _pages = [];

  EbisuRouter () {
    this._addPages();
  }

  void _addPages () {
    this._pages.add(HomePage());
    this._pages.add(CreateExpenditurePage());
    this._pages.add(ListExpenditurePage());
  }

  List<AbstractPage> get pages => _pages;
}