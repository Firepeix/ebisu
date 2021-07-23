import 'package:ebisu/src/Infrastructure/Router/EbisuRouter.dart';
import 'package:ebisu/src/UI/Components/Nav/BottomNavBar.dart';
import 'package:ebisu/src/UI/Components/Nav/MainButtonPage.dart';
import 'package:ebisu/src/UI/Expenditures/Create.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ebisu',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'Home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  final EbisuRouter router = EbisuRouter();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentPage = 0;

  void _changePageTo(int pageIndex) {
    setState(() {
      currentPage = pageIndex;
    });
  }

  FloatingActionButton _getMainButton() {
    var page = widget.router.pages[currentPage];
    if (page is MainButtonPage) {
      var mainButtonPage = (page as MainButtonPage);
      return mainButtonPage.getMainButton();
    }
    return this._getDefaultMainButton();
  }

  FloatingActionButton _getDefaultMainButton() {
    return FloatingActionButton(
      onPressed: () {
        this._changePageTo(CreateExpenditurePage.PAGE_INDEX);
      },
      tooltip: "Adicionar Nova Despesa",
      child: Icon(Icons.add),
      elevation: 2.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Visibility(
        visible: !keyboardIsOpen,
        child: this._getMainButton(),
      ),
      bottomNavigationBar: BottomNavBar(
          onTabSelected: (int value) => _changePageTo(value),
          centerItemText: 'Despesa',
          selectedIndex: currentPage
      ),
      body: widget.router.pages[currentPage],
    );
  }
}
