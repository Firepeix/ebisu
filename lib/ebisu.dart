import 'package:ebisu/configuration/UI/Pages/Configuration.dart';
import 'package:ebisu/main.dart';
import 'package:ebisu/modules/expenditure/events/change_main_button_on_action_notification.dart';
import 'package:ebisu/modules/expenditure/pages/create_expenses.dart';
import 'package:ebisu/modules/expenditure/pages/edit_expense.dart';
import 'package:ebisu/modules/expenditure/pages/list_expenses.dart';
import 'package:ebisu/modules/income/entry/page/create_income_page.dart';
import 'package:ebisu/modules/layout/core/domain/main_action.dart';
import 'package:ebisu/modules/layout/entry/components/botton_nav_bar.dart';
import 'package:ebisu/modules/layout/entry/components/main_action_button.dart';
import 'package:ebisu/shared/navigator/navigator_interface.dart';
import 'package:ebisu/shared/utils/list.dart';
import 'package:ebisu/src/UI/Components/Nav/MainButtonPage.dart';
import 'package:ebisu/src/UI/General/HomePage.dart';
import 'package:ebisu/ui_components/chronos/layout/home_view.dart';
import 'package:flutter/material.dart';

import 'modules/layout/components/drawer.dart';

typedef ChangeExistentIndex = Function(int);

class EbisuMainView extends StatefulWidget {
  final bool enableBackButton;
  final Map<int, HomeView>? pages;
  final int initialPage;

  EbisuMainView({this.enableBackButton = false, this.pages, this.initialPage = 0});

  @override
  EbisuMainViewState createState() => EbisuMainViewState();
}

class EbisuMainViewState extends State<EbisuMainView> {
  List<HomeView> _pages = [];
  HomeView? currentPage;
  int currentPageIndex = 0;
  List<int> _pageStack = [];
  VoidCallback? onMainButtonPressed;

  @override
  void initState() {
    super.initState();
    currentPageIndex  = widget.initialPage;
    _addPages();
    changePageTo(currentPageIndex);
  }

  Widget _getMainButton(BuildContext context) {
    final actions = {
      MainAction.ADD_EXPENSE: () => changePageTo(CreateExpenditurePage.PAGE_INDEX),
      MainAction.ADD_INCOME: () => changePageTo(CreateIncomePage.PAGE_INDEX),
    };

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

    return MainActionButton(actions);
  }

  void pushLastPage(int page) {
    if (_pageStack.length >= 5) {
      _pageStack.removeAt(4);
    }
    _pageStack.insert(0, page);
  }

  void popStack() {
    if(_pageStack.isNotEmpty) {
      _pageStack.removeAt(0);
    }
  }

  void changePageTo(int pageIndex, {bool isReturn = false}) {
    setState(() {
      isReturn ? popStack() : pushLastPage(currentPageIndex);
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
    this._pages.add(HomePage(onClickExpense: (e) {
      routeTo(context, EbisuMainView(enableBackButton: true, pages: {4: UpdateExpensePage(e.id, onSaveExpense: (v) => routeToBack(context),)}, initialPage: 4,), animation: IntoViewAnimation.pop);
    },));
    this._pages.add(CreateExpenditurePage(onSaveExpense: (value) => this.changePageTo(value),));
    this._pages.add(ListExpendituresPage(onClickExpense: (value) => this.changeTo(value), onSaveExpense: (value) => this.changePageTo(value),));
    this._pages.add(CreateIncomePage(onDone: () => changePageTo(0),));

    widget.pages?.forEach((key, value) {
      _pages.replace(key, value);
    });
  }

  Widget build(BuildContext context) {
    bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    final _mainButton = _getMainButton(context);
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
              routeTo(context, ConfigurationPage());
            },
          )
        ],
      ),
      drawer: EbisuDrawer(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Visibility(
        visible: !keyboardIsOpen,
        child: _getMainButton(context),
      ),
      bottomNavigationBar: BottomNavBar(
        onTabSelected: (int value) => changePageTo(value),
        centerItemText: _mainButton is FloatingActionButton && _mainButton.tooltip != null ? _mainButton.tooltip! : "Adicionar",
        selectedIndex: currentPageIndex,
      ),
      body: PopScope(
        canPop: widget.enableBackButton,
        child: NotificationListener<ChangeMainButtonActionNotification>(
          child: currentPage != null ? currentPage! : Column(),
          onNotification: (notification) {
            onMainButtonPressed = notification.onPressed;
            return true;
          },
        ),
        onPopInvoked: (didPop) {
          if (widget.enableBackButton == false) {
            if (_pageStack.isEmpty) {
              return changePageTo(0);
            }

            if(currentPageIndex != _pageStack[0]) {
              changePageTo(_pageStack[0], isReturn: true);
            }
          }
        },
      ),
    );
  }
}