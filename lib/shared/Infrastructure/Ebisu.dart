import 'package:ebisu/modules/core/core.dart';
import 'package:ebisu/modules/expenditure/events/change_main_button_on_action_notification.dart';
import 'package:ebisu/modules/expenditure/pages/create_expenses.dart';
import 'package:ebisu/modules/expenditure/pages/list_expenses.dart';
import 'package:ebisu/shared/dependency/dependency_container.dart';
import 'package:ebisu/src/UI/Components/Nav/BottomNavBar.dart';
import 'package:ebisu/src/UI/Components/Nav/MainButtonPage.dart';
import 'package:ebisu/src/UI/General/HomePage.dart';
import 'package:ebisu/ui_components/chronos/layout/home_view.dart';
import 'package:flutter/material.dart';

typedef ChangeExistentIndex = Function(int);

class EbisuMainView extends StatefulWidget {

  Widget getDrawer() {
    return DependencyManager.get<CoreInterface>().getDrawer();
  }

  @override
  EbisuMainViewState createState() => EbisuMainViewState();
}

class EbisuMainViewState extends State<EbisuMainView> {
  List<HomeView> _pages = [];
  HomeView? currentPage;
  int currentPageIndex = 0;
  VoidCallback? onMainButtonPressed;

  @override
  void initState() {
    super.initState();
    _addPages();
    changePageTo(currentPageIndex);
  }

  FloatingActionButton _getMainButton(BuildContext context) {
    if (currentPage is MainButtonPage) {
      var mainButtonPage = (currentPage as MainButtonPage);
      return mainButtonPage.getMainButton(context, () {
        if (onMainButtonPressed == null) {
          setState(() {});
          return;
        }

        onMainButtonPressed?.call();
      });
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

  void changeTo(HomeView page) {
    setState(() {
      _pages.insert(page.pageIndex(), page);
      currentPageIndex = page.pageIndex();
      currentPage = _pages[currentPageIndex];
    });
  }

  void _addPages () {
    this._pages.add(HomePage());
    this._pages.add(CreateExpenditurePage(onSaveExpense: (value) => this.changePageTo(value),));
    this._pages.add(ListExpendituresPage(onClickExpense: (value) => this.changeTo(value), onSaveExpense: (value) => this.changePageTo(value),));
  }

  Widget build(BuildContext context) {
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
      drawer: widget.getDrawer(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Visibility(
        visible: !keyboardIsOpen,
        child: _getMainButton(context),
      ),
      bottomNavigationBar: BottomNavBar(
          onTabSelected: (int value) => changePageTo(value),
          centerItemText: 'Despesa',
          selectedIndex: currentPageIndex,
      ),
      body: NotificationListener<ChangeMainButtonActionNotification>(
        child: currentPage != null ? currentPage! : Column(),
        onNotification: (notification) {
          onMainButtonPressed = notification.onPressed;
          return true;
        },
      ),
    );
  }
}