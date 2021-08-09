import 'package:ebisu/shared/Domain/Bus/Command.dart';
import 'package:ebisu/shared/UI/Components/Title.dart';
import 'package:ebisu/src/Domain/Pages/AbstractPage.dart';
import 'package:flutter/material.dart';

class ExpenditureHomePage extends AbstractPage {
  @override
  Widget build(BuildContext context) {
    return _Content();
  }
}

class _Content extends StatefulWidget {
  Widget _getDefaultScreen () => Padding(
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.paid_outlined, size: 300,)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Bem Vindo', style: TextStyle(fontSize: 60, fontWeight: FontWeight.w600),)
            ],
          )
        ],
      )
  );




  Widget _getHomeDashboard () => Column(
    children: [
      EbisuTitle()
    ],
  );

  Widget build (_ContentState state) {
    return RefreshIndicator(
        child: state.loaded ? _getHomeDashboard() : _getDefaultScreen(),
        onRefresh: () async {
          return print(12);
        }
    );
  }

  @override
  State<StatefulWidget> createState() => _ContentState();
}

class _ContentState extends State<_Content> with DispatchesCommands {
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    _setInitialState();
  }

  void _setInitialState () async {
    //setExpenditures();
    setState(() {
      loaded = true;
    });
  }

  /*Future<void> setExpenditures ({cacheLess: false}) async {
    final expenditures = await dispatch(new GetExpendituresCommand(cacheLess));
    setState(() {
      this.expenditures = expenditures;
    });
    return Future.value();
  }*/

  @override
  Widget build(BuildContext context) => widget.build(this);

}