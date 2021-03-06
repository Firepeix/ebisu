import 'package:ebisu/expenditure/UI/Pages/CreateExpenditure.dart';
import 'package:ebisu/expenditure/UI/Pages/ListExpenditures.dart';
import 'package:ebisu/modules/core/core.dart';
import 'package:ebisu/shared/dependency/dependency_container.dart';
import 'package:ebisu/src/Domain/Pages/AbstractPage.dart';
import 'package:ebisu/src/UI/Components/Nav/BottomNavBar.dart';
import 'package:ebisu/src/UI/Components/Nav/MainButtonPage.dart';
import 'package:ebisu/src/UI/General/HomePage.dart';
import 'package:flutter/material.dart';

class EbisuMainView extends StatefulWidget {


  Widget getDrawer() {
    return DependencyManager.get<CoreInterface>().getDrawer();
  }

  @override
  _EbisuMainViewState createState() => _EbisuMainViewState();

  Widget build(_EbisuMainViewState state, BuildContext context) {
    bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      appBar: AppBar(
        title: Text('Ebisu'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              size: 26.0,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/configuration');
            },
          )
        ],
      ),
      drawer: getDrawer(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Visibility(
        visible: !keyboardIsOpen,
        child: state._getMainButton(context),
      ),
      bottomNavigationBar: BottomNavBar(
          onTabSelected: (int value) => state.changePageTo(value),
          centerItemText: 'Despesa',
          selectedIndex: state.currentPageIndex
      ),
      body: state.currentPage != null ? state.currentPage : Column(),
    );
  }
}

class _EbisuMainViewState extends State<EbisuMainView> {
  List<AbstractPage> _pages = [];
  AbstractPage? currentPage;
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _addPages();
    changePageTo(currentPageIndex);
  }

  FloatingActionButton _getMainButton(BuildContext context) {
    if (currentPage is MainButtonPage) {
      var mainButtonPage = (currentPage as MainButtonPage);
      return mainButtonPage.getMainButton(context);
    }
    return this._getDefaultMainButton();
  }

  FloatingActionButton _getDefaultMainButton() {
    return FloatingActionButton(
      onPressed: () {
        this.changePageTo(CreateExpenditurePage.PAGE_INDEX);
      },
      tooltip: "Adicionar Nova Despesa",
      child: Icon(Icons.add),
      elevation: 2.0,
    );
  }

  void changePageTo(int pageIndex) {
    setState(() {
      currentPageIndex = pageIndex;
      currentPage = _pages[currentPageIndex];
    });
  }

  void _addPages () {
    this._pages.add(HomePage());
    this._pages.add(CreateExpenditurePage(onChangePageTo: (value) => this.changePageTo(value),));
    this._pages.add(ListExpendituresPage());
  }

  Widget build(BuildContext context) => widget.build(this, context);
}